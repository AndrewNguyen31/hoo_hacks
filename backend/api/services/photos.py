import asyncio
import json
import os

from aiohttp import ClientSession, ClientTimeout
from urllib.parse import urlparse, urlencode
from playwright.async_api import async_playwright
from PIL import Image as PILImage

class PhotoExtractor:
    # Function to extract the domain from a URL
    def extract_domain(self, url):
        """
        Extract the domain from the given URL.
        If the domain starts with 'www.', it removes it.

        Args:
            url (str): The URL to extract the domain from.

        Returns:
            str: The extracted domain.
        """
        domain = urlparse(url).netloc
        if domain.startswith("www."):
            domain = domain[4:]
        return domain

    # Function to download an image with retry logic
    async def download_image(self, session, img_url, file_path, retries=3):
        """
        Download an image and convert it to JPG if necessary
        """
        attempt = 0
        while attempt < retries:
            try:
                async with session.get(img_url) as response:
                    if response.status == 200:
                        # Write the original image first
                        temp_path = file_path + ".temp"
                        with open(temp_path, "wb") as f:
                            f.write(await response.read())
                        
                        # Convert to JPG if needed
                        with PILImage.open(temp_path) as img:
                            # Convert to RGB mode (removes alpha channel if present)
                            if img.mode in ('RGBA', 'P'):
                                img = img.convert('RGB')
                            
                            # Always save as JPG
                            jpg_path = os.path.splitext(file_path)[0] + '.jpg'
                            img.save(jpg_path, 'JPEG', quality=95)
                            
                        # Remove temporary file
                        os.remove(temp_path)
                        print(f"Downloaded and converted image to: {jpg_path}")
                        return jpg_path
                    else:
                        print(f"Failed to download image from {img_url}. Status: {response.status}")
            except Exception as e:
                print(f"Error downloading/converting image from {img_url}: {e}")
            attempt += 1
            if attempt < retries:
                print(f"Retrying download for {img_url} (attempt {attempt + 1}/{retries})")
                await asyncio.sleep(2**attempt)
        print(f"Failed to download image from {img_url} after {retries} attempts.")
        return None

    # Main function to scrape Google Images
    async def scrape_google_images(self, search_query="Doctor", timeout_duration=10):
        """
        Scrape exactly 7 images from Google Images for a given search query.
        Runs in headless mode without showing browser window.

        Args:
            search_query (str, optional): The search term to use for Google Images. Defaults to "Doctor".
            timeout_duration (int, optional): The timeout duration for the image download session. Defaults to 10 seconds.

        Returns:
            None
        """
        async with async_playwright() as p:
            browser = await p.chromium.launch(headless=True)
            page = await browser.new_page()

            query_params = urlencode({"q": search_query, "tbm": "isch"})
            search_url = f"https://www.google.com/search?{query_params}"

            print(f"Navigating to search URL: {search_url}")
            await page.goto(search_url)

            # Remove scroll_to_bottom call and just wait for the initial images to load
            await page.wait_for_selector('div[data-id="mosaic"]')

            # Set up directories for image storage
            download_folder = "../../../assets/images"
            metadata_folder = "../../../assets/metadata"
            json_file_path = os.path.join(metadata_folder, "google_images_data.json")

            # Clean out existing directories
            if os.path.exists(download_folder):
                print(f"Cleaning previous image_ files from directory: {download_folder}")
                # Only remove files that start with 'image_'
                for file in os.listdir(download_folder):
                    if file.startswith('image_'):
                        file_path = os.path.join(download_folder, file)
                        os.remove(file_path)
                        print(f"Removed: {file}")
            else:
                os.makedirs(download_folder)

            if os.path.exists(metadata_folder):
                print(f"Cleaning metadata directory: {metadata_folder}")
                if not os.path.exists(metadata_folder):
                    os.makedirs(metadata_folder)

            # Initialize empty JSON file
            with open(json_file_path, "w") as json_file:
                json.dump([], json_file)

            # Find all image elements on the page
            image_elements = await page.query_selector_all('div[data-attrid="images universal"]')
            print(f"Found {len(image_elements)} image elements on the page.")

            async with ClientSession(timeout=ClientTimeout(total=timeout_duration)) as session:
                images_downloaded = 0
                image_data_list = []

                # Iterate through the first 7 image elements
                for idx, image_element in enumerate(image_elements):
                    if images_downloaded >= 7:  # Hard limit of 5 images
                        print("Reached 7 images. Stopping download.")
                        break
                    try:
                        print(f"Processing image {idx + 1}...")
                        await image_element.click()
                        await page.wait_for_selector("img.sFlh5c.FyHeAf.iPVvYb[jsaction]")

                        img_tag = await page.query_selector("img.sFlh5c.FyHeAf.iPVvYb[jsaction]")
                        if not img_tag:
                            print(f"Failed to find image tag for element {idx + 1}")
                            continue

                        img_url = await img_tag.get_attribute("src")
                        # Always use .jpg extension now
                        file_path = os.path.join(download_folder, f"image_{idx + 1}")
                        
                        # download_image now returns the actual path used
                        actual_file_path = await self.download_image(session, img_url, file_path)
                        
                        if not actual_file_path:
                            continue

                        source_url = await page.query_selector('(//div[@jsname="figiqf"]/a[@class="YsLeY"])[2]')
                        source_url = await source_url.get_attribute("href") if source_url else "N/A"
                        image_description = await img_tag.get_attribute("alt")
                        source_name = self.extract_domain(source_url)

                        image_data = {
                            "image_description": image_description,
                            "source_url": source_url,
                            "source_name": source_name,
                            "image_file": actual_file_path,
                        }

                        image_data_list.append(image_data)
                        print(f"Image {idx + 1} metadata prepared.")
                        images_downloaded += 1
                    except Exception as e:
                        print(f"Error processing image {idx + 1}: {e}")
                        continue

                # Save image metadata to JSON file
                with open(json_file_path, "w") as json_file:
                    json.dump(image_data_list, json_file, indent=4)

            print(f"Finished downloading {images_downloaded} images.")
            await browser.close()

# # Create an instance and run
# extractor = PhotoExtractor()
# asyncio.run(extractor.scrape_google_images(search_query="Broken Collarbone", timeout_duration=10))