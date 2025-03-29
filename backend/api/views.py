from rest_framework.decorators import api_view
from django.http import JsonResponse
from .services.text_similarity import TextSimilarity
from .services.simplify_message import SimplifyMessage
from .services.translate_message import TranslateMessage

import json

text_similarity = TextSimilarity()
simplify_message = SimplifyMessage()
translate_message = TranslateMessage()

@api_view(['POST'])
def process_text(request):
    try:
        data = json.loads(request.body)
        original_text = data.get('text', '')
        
        # Step 1: Simplify
        simplified_text = simplify_message.simplify(original_text)
        
        # Step 2: Translate
        translated_text = translate_message.translate(simplified_text)
        
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