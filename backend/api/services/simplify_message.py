import os
from dotenv import load_dotenv
from google import generativeai


"""
Prompt

Task Background	
You are a medical language simplifier. Given complex medical sentences from a healthcare provider, your task is to rewrite the content in a way that is easy for patients to understand. Use plain language while preserving the meaning. Focus on:
Removing medical jargon.
Explaining terms in patient-friendly language.
Using a calm and reassuring tone.
Adapting to cultural sensitivity when necessary.

Given the medical text:
"Patient has hypertension and may require antihypertensive therapy to reduce the risk of myocardial infarction."
Question: Rewrite this for patient understanding.
Answer:
"First, we identify medical jargon: 'hypertension' means 'high blood pressure'; 'antihypertensive therapy' means 'medicine to lower blood pressure'; 'myocardial infarction' means 'heart attack'.
Putting it all together in simpler words:
'You have high blood pressure, and we may need to give you medicine to lower it and help prevent a heart attack.'"

Given the medical text:
"We will schedule an MRI to evaluate potential meniscal degeneration in your knee joint."
Question: Rewrite this for patient understanding.
Answer:
"'MRI' is a special kind of scan that shows inside your body. 'Meniscal degeneration' refers to wearing down of the cushioning in your knee.
Putting it all together in simpler words:
'We will schedule a special scan to check if the cushion in your knee is wearing down.'"
Final prompt
Task background
+
CoT Based Few-shot Examples
+
Given the medical text: Input Medical Text
Question: Rewrite this for patient understanding.
Answer:
"""

class SimplifyMessage:
    def load_env(self):
        load_dotenv()
        self.api_key = os.getenv("GOOGLE_API_KEY")
        # Configure the Gemini API
        generativeai.configure(api_key=self.api_key)
        # Create model instances
        self.gemini_model = generativeai.GenerativeModel('gemini-2.0-flash')

    def simplify_message(self, message) -> str:
        instruction = "Task Background: You are a medical language simplifier. Given complex medical sentences from a healthcare provider, your task is to rewrite the content in a way that is easy for patients to understand. Use plain language while preserving the meaning. Focus on: Removing medical jargon. Explaining terms in patient-friendly language. Using a calm and reassuring tone. Adapting to cultural sensitivity when necessary. Remember, you are only simplifying the message. Do not include thought process or rationale. Just return a simplified version of the input message and remember to be sensitive to the patients feelings when writing the simplified message.  Here is the medical text: " + message

        few_shot_examples = "Here are some examples of how you should simplify medical messages: The imaging shows a localized malignant neoplasm in the left lung lobe, requiring biopsy for confirmation. --- SIMPLIFIED:The scan found a small area of cancer in your left lung. We need to do a test called a biopsy to be sure."

        final_prompt = instruction + "\n\n" + few_shot_examples

        try:
            response = self.gemini_model.generate_content(instruction)
            return response.text
        except Exception as e:
            return f"An error occurred: {str(e)}"
