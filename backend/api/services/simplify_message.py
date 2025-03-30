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

    def simplify_message_easy(self, message) -> str:
        instruction = "Task Background: You are a medical language simplifier. Given complex medical sentences from a healthcare provider, your task is to rewrite the content in a way that is very easy for patients to understand. Use plain language while preserving the meaning. Focus on: Removing medical jargon. Explaining terms in patient-friendly language. Using a calm and reassuring tone. Adapting to cultural sensitivity when necessary. Remember, you are only simplifying the message. Do not include thought process or rationale. Just return a simplified version of the input message and remember to be sensitive to the patients feelings when writing the simplified message.  Here is the medical text: " + message

        few_shot_examples = "Here are some examples of how you should simplify medical messages: The imaging shows a localized malignant neoplasm in the left lung lobe, requiring biopsy for confirmation. --- SIMPLIFIED:The scan found a small area of cancer in your left lung. We need to do a test called a biopsy to be sure."

        final_prompt = instruction + "\n\n" + few_shot_examples

        try:
            response = self.gemini_model.generate_content(final_prompt)
            return response.text
        except Exception as e:
            return f"An error occurred: {str(e)}"

    def simplify_message_intermediate(self, message) -> str:
        instruction = "Task Background: You are a medical language simplifier. Given complex medical sentences from a healthcare provider, your task is to rewrite the content in a way that patients with moderate amounts of domain knowledge can understand. Use plain language while preserving the meaning. Focus on: Removing medical jargon. Explaining terms in patient-friendly language. Using a calm and reassuring tone. Adapting to cultural sensitivity when necessary. Remember, you are only simplifying the message. Do not include thought process or rationale. Just return a simplified version of the input message and remember to be sensitive to the patients feelings when writing the simplified message.  Here is the medical text: " + message

        few_shot_examples = "Here are some examples of how you should simplify medical messages: The imaging shows a localized malignant neoplasm in the left lung lobe, requiring biopsy for confirmation. --- SIMPLIFIED: You have a mild case of pneumonia, which is an infection in your lungs. We're treating it with antibiotics to help you get better."

        final_prompt = instruction + "\n\n" + few_shot_examples

        try:
            response = self.gemini_model.generate_content(final_prompt)
            return response.text
        except Exception as e:
            return f"An error occurred: {str(e)}"
        
    def simplify_message_advanced(self, message) -> str:
        instruction = "Task Background: You are a medical language simplifier. Given complex medical sentences from a healthcare provider, your task is to rewrite the content for recipients with advanced medical knowledge and expertise. Use appropriate technical language while preserving clinical accuracy. Focus on: Maintaining precise medical terminology, Providing sufficient technical detail, Using a professional and scientifically rigorous tone, Being culturally sensitive and appropriate. Remember, you are only simplifying the message for an advanced audience. Do not include thought process or rationale. Just return a technically accurate version of the input message that would be appropriate for someone with strong medical domain knowledge. Here is the medical text: " + message

        few_shot_examples = "Here are some examples of how you should simplify medical messages: The imaging shows a localized malignant neoplasm in the left lung lobe, requiring biopsy for confirmation. --- SIMPLIFIED: Patient presents with mild bacterial pneumonia characterized by lower respiratory tract infection. Treatment protocol initiated with broad-spectrum antibiotic therapy to target the causative pathogen."

        final_prompt = instruction + "\n\n" + few_shot_examples

        try:
            response = self.gemini_model.generate_content(final_prompt)
            return response.text
        except Exception as e:
            return f"An error occurred: {str(e)}"
        
    def client_to_doctor(self, message) -> str:
        instruction = "Task Background: You are a communication assistant helping patients clearly express their symptoms and concerns to healthcare providers. Given a patient's description, your task is to help articulate their thoughts more clearly while keeping their original words and meaning. Focus on: Organizing their thoughts in a clear structure, Maintaining their own descriptions and terminology, Ensuring all their concerns are expressed clearly, Preserving the timeline of their symptoms. Do not translate terms into medical language or ask for additional information. Also, do not provide any rationale or thought process - simply help structure and clarify their existing message. Here is the patient's description: " + message

        few_shot_examples = "Here are some examples of how you should assist in articulation of client messages: I have a headache and a cough. I have been coughing for 3 days and the headache started yesterday.. --- TRANSFORMED INTO: I'm experiencing a headache and a cough. The cough started three days ago. The headache began yesterday."

        final_prompt = instruction + "\n\n" + few_shot_examples

        try:
            response = self.gemini_model.generate_content(final_prompt)
            return response.text
        except Exception as e:
            return f"An error occurred: {str(e)}"

        
    def extract_idea(self, message) -> str:
        instruction = "Task Background: You are a medical language simplifier. Given complex medical sentences from a healthcare professional, you task is to extract the illness or condition that the patient has. I want you to return the illness or condition only, nothing else Here is the medical text: " + message

        few_shot_examples = "Here are some examples of how you should extract the main idea of a medical sentence: The patient has a mild case of pneumonia and is being treated with antibiotics. --- MAIN IDEA: pneumonia"

        final_prompt = instruction + "\n\n" + few_shot_examples

        try:
            response = self.gemini_model.generate_content(final_prompt)
            return response.text
        except Exception as e:
            return f"An error occurred: {str(e)}"
