import numpy as np

from sentence_transformers import SentenceTransformer

class TextSimilarity:
    def __init__(self):
        # Initialize the model - using a multilingual model for better language support
        self.model = SentenceTransformer('paraphrase-multilingual-MiniLM-L12-v2')
    
    def calculate_similarity(self, text1: str, text2: str) -> float:
        """
        Calculate semantic similarity between two texts.
        
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