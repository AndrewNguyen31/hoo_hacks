import numpy as np
from sentence_transformers import SentenceTransformer
from dotenv import load_dotenv
import os
import google.generativeai as generativeai
import math

class TextSimilarity:
    def __init__(self):
        self.model = SentenceTransformer('all-mpnet-base-v2') 

    def load_env(self):
        load_dotenv()
        self.api_key = os.getenv("GOOGLE_API_KEY")
        # Configure the Gemini API
        generativeai.configure(api_key=self.api_key)
        # Create model instances
        self.gemini_model = generativeai.GenerativeModel('gemini-2.0-flash')

    
    def calculate_similarity_embeddings(self, text1: str, text2: str) -> float:
        """
        Calculate semantic similarity between two texts using embeddings.
        
        Args:
            text1 (str): First text to compare
            text2 (str): Second text to compare
            
        Returns:
            float: Similarity score (0-1) 
        """
        # Generate embeddings for both texts
        embedding1 = self.model.encode(text1, convert_to_tensor=True)
        embedding2 = self.model.encode(text2, convert_to_tensor=True)
        
        # Move tensors to CPU before converting to numpy
        embedding1 = embedding1.cpu().numpy()
        embedding2 = embedding2.cpu().numpy()
        
        # Calculate cosine similarity
        similarity = float(np.inner(embedding1, embedding2) / 
                         (np.linalg.norm(embedding1) * np.linalg.norm(embedding2)))
            
        return similarity
    
    def calculate_similarity_llm(self, text1: str, text2: str) -> float:
        """
        Calculate semantic similarity between two texts using Gemini LLM.
        
        Args:
            text1 (str): First text to compare
            text2 (str): Second text to compare
            
        Returns:
            float: Similarity score (0-1)
        """
        # Ensure the API is configured
        if not hasattr(self, 'gemini_model'):
            self.load_env()
            
        # Create prompt for Gemini
        prompt = f"""
        Compare the semantic similarity between these two texts and return a single float value 
        between 0 and 1, where 0 means completely different and 1 means identical in meaning.
        
        Focus on the underlying concepts, ideas, and information rather than exact wording.
        Two texts should receive a high score (0.8-1.0) if they convey the same core information 
        or serve the same purpose, even if they use different words or sentence structures.
        
        Be generous with your scoring - if texts are conveying similar information or concepts, 
        they should receive at least a 0.8 score, even if the phrasing is different or they're in different languages.
        
        Text 1: "{text1}"
        
        Text 2: "{text2}"
        
        Return only a single float number between 0 and 1 without any explanation. Do not include any other text in your response.
        """
        
        # Get response from Gemini
        response = self.gemini_model.generate_content(prompt)
        
        try:
            # Extract the float value from the response
            similarity_score = float(response.text.strip())
            # Ensure value is in range 0-1
            similarity_score = max(0.0, min(1.0, similarity_score))
            return similarity_score
        except (ValueError, AttributeError):
            # Fallback in case the LLM doesn't respond with a valid float
            print("Warning: Gemini did not return a valid float. Using default score.")
            return 0.5
    
    def calculate_combined_similarity(self, text1: str, text2: str) -> float:
        """
        Calculate similarity using both embedding-based and LLM-based methods
        and return the average score.
        
        Args:
            text1 (str): First text to compare
            text2 (str): Second text to compare
            
        Returns:
            float: Combined similarity score (0-1)
        """
        embedding_score = self.calculate_similarity_embeddings(text1, text2)
        llm_score = self.calculate_similarity_llm(text1, text2)
        
        # Give more weight to LLM-based similarity as it's better at understanding semantic meaning
        # Add a small constant to the LLM score to ensure it's not too low (biased result)
        # Embedding score is more discriminative, so we add bias term
        raw_combined_score = (0.4 * (embedding_score + 0.1)) + (0.6 * (llm_score + 0.2))
        
        # Normalize using a sigmoid function to keep it between 0 and 1 with a smooth transition
        combined_score = 1 / (1 + math.exp(-5 * (raw_combined_score - 0.5)))
        
        return combined_score
    
