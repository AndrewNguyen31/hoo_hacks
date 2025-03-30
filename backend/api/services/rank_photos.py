import os
import json
from PIL import Image

from google import genai
from google.genai import types
from text_similarity import TextSimilarity
from dotenv import load_dotenv

class PhotoRanker:
    def __init__(self):
        self.text_similarity = TextSimilarity()
        # Configure Gemini API
        load_dotenv()
        self.client = genai.Client()

    async def generate_image_description(self, image_path):
        """
        Generate a descriptive prompt from the image using Gemini 2.0 Flash experimental
        """
        try:
            # Load image
            image = Image.open(image_path)
            
            # Create prompt for comprehensive image analysis
            text_input = "Describe this medical image in concise technical language, focusing on imaging type, anatomical region, and any visible conditions. Limit your response to a single sentence"

            # Generate description using Gemini 2.0 Flash
            response = self.client.models.generate_content(
                model="gemini-2.0-flash-exp-image-generation",
                contents=[text_input, image],
                config=types.GenerateContentConfig(
                    response_modalities=['Text']
                )
            )
            
            # Extract text response
            for part in response.candidates[0].content.parts:
                if part.text is not None:
                    return part.text
            
            return ""
        except Exception as e:
            print(f"Error generating image description: {e}")
            print(f"Error type: {type(e)}")
            print(f"Error details: {str(e)}")
            return ""

    async def rank_photos(self, original_prompt):
        """
        Rank downloaded images and update the existing google_images_data.json
        with only the top 5 most relevant images
        """
        images_folder = "../../../assets/images"
        metadata_folder = "../../../assets/metadata"
        json_file_path = os.path.join(metadata_folder, "google_images_data.json")
        ranked_images = []

        # Read existing metadata
        with open(json_file_path, 'r') as f:
            existing_metadata = json.load(f)

        # Process and rank all images
        for image_data in existing_metadata:
            image_path = image_data['image_file']
            
            # Generate description for the image
            image_description = await self.generate_image_description(image_path)
            
            # Calculate similarity score
            similarity_score = self.text_similarity.calculate_similarity(
                original_prompt, 
                image_description
            )

            ranked_images.append({
                **image_data,  # Keep all existing metadata
                'ai_description': image_description,  # Add AI-generated description
                'similarity_score': similarity_score
            })

        # Sort images by similarity score and get top 5
        ranked_images.sort(key=lambda x: x['similarity_score'], reverse=True)
        top_five_images = ranked_images[:5]

        # Clean up unused images that start with 'image_'
        removed_images = ranked_images[5:]
        for image in removed_images:
            filename = os.path.basename(image['image_file'])
            if filename.startswith('image_'):
                try:
                    image_path = os.path.join(images_folder, filename)
                    os.remove(image_path)
                    print(f"Removed unused image: {filename}")
                except Exception as e:
                    print(f"Error removing file {filename}: {e}")

        # Update the original JSON file with only top 5
        with open(json_file_path, 'w') as f:
            json.dump(top_five_images, f, indent=4)

        return top_five_images

# Update the test function
if __name__ == "__main__":
    import asyncio
    
    async def test_ranking():
        ranker = PhotoRanker()
        rankings = await ranker.rank_photos("Broken Collarbone")
        print("\nTop 5 Images (updated in google_images_data.json):")
        for rank, image in enumerate(rankings, 1):
            print(f"\nRank {rank}:")
            print(f"File: {image['image_file']}")
            print(f"Original Description: {image['image_description']}")
            print(f"AI Description: {image['ai_description']}")
            print(f"Similarity Score: {image['similarity_score']:.4f}")

    asyncio.run(test_ranking())