from rest_framework.decorators import api_view
from django.http import JsonResponse
from .services.text_similarity import TextSimilarity
from .services.simplify_message import SimplifyMessage
from .services.translate_message import TranslateMessage

import json
import os

text_similarity = TextSimilarity()
simplify_message = SimplifyMessage()
translate_message = TranslateMessage()

@api_view(['POST'])
def process_text(request):
    try:
        data = json.loads(request.body)
        original_text = data.get('text', '')
        
        # Step 1: Simplify
        simplify_message.load_env()
        simplified_text = simplify_message.simplify_message(original_text)
        
        # Step 2: Translate
        os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = './api/hoo-hacks.json'
        translated_text = translate_message.translate_text(simplified_text, "en")
        
        # Step 3: Calculate similarity
        similarity_score = text_similarity.calculate_similarity(original_text, translated_text)
        
        return JsonResponse({
            'original_text': original_text,
            'simplified_text': simplified_text,
            'translated_text': translated_text,
            'similarity_score': similarity_score,
            'status': 'success'
        })
    except Exception as e:
        return JsonResponse({
            'error': str(e),
            'status': 'error'
        }, status=400)