from rest_framework.decorators import api_view
from django.http import JsonResponse
from .services.text_similarity import TextSimilarity
from .services.simplify_message import SimplifyMessage
from .services.translate_message import TranslateMessage

import html
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
        process_all_levels = data.get('process_all_levels', False)
        target_language = data.get('language', 'en')  # Get target language from request
        
        translations = []
        
        # Process all levels if requested
        if process_all_levels:
            levels = ['easy', 'intermediate', 'advanced']
            for level in levels:
                # Step 1: Simplify based on level
                simplify_message.load_env()
                if level == 'easy':
                    simplified_text = simplify_message.simplify_message_easy(original_text)
                elif level == 'intermediate':
                    simplified_text = simplify_message.simplify_message_intermediate(original_text)
                else:  # advanced
                    simplified_text = simplify_message.simplify_message_advanced(original_text)
                
                # Step 2: Translate
                os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = './api/hoo-hacks.json'
                translated_text = translate_message.translate_text(simplified_text, target_language)
                translated_text = html.unescape(translated_text)
                
                # Step 3: Calculate similarity
                similarity_score = text_similarity.calculate_similarity(original_text, translated_text)
                
                translations.append({
                    'level': level,
                    'translated_text': translated_text,
                    'similarity_score': similarity_score,
                    'target_language': target_language
                })
            
            return JsonResponse({
                'original_text': original_text,
                'translations': translations,
                'status': 'success'
            })
        else:
            # Handle single level case (backwards compatibility)
            level = data.get('level', 'easy')
            # Step 1: Simplify based on level
            simplify_message.load_env()
            if level == 'easy':
                simplified_text = simplify_message.simplify_message_easy(original_text)
            elif level == 'intermediate':
                simplified_text = simplify_message.simplify_message_intermediate(original_text)
            else:  # advanced
                simplified_text = simplify_message.simplify_message_advanced(original_text)
            
            # Step 2: Translate
            os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = './api/hoo-hacks.json'
            translated_text = translate_message.translate_text(simplified_text, target_language)
            translated_text = html.unescape(translated_text)
            
            # Step 3: Calculate similarity
            similarity_score = text_similarity.calculate_similarity(original_text, translated_text)
            
            return JsonResponse({
                'original_text': original_text,
                'translated_text': translated_text,
                'similarity_score': similarity_score,
                'level': level,
                'target_language': target_language,
                'status': 'success'
            })
            
    except Exception as e:
        return JsonResponse({
            'error': str(e),
            'status': 'error'
        }, status=400)