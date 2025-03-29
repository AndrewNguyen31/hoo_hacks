from google.cloud import translate_v2 as translate

class TranslateMessage:
    def translate_text(self, text, target_language='en'):
        translate_client = translate.Client()
        try:
            result = translate_client.translate(
                text,
                target_language=target_language
            )
            return result['translatedText']
        except Exception as e:
            return f"Translation error: {str(e)}"