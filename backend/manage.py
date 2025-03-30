#!/usr/bin/env python
"""Django's command-line utility for administrative tasks."""
import os
import sys


def clear_images():
    """Clear all images starting with 'image_' from assets/images folder"""
    images_folder = "../assets/images"
        
    try:
        found = False
        for filename in os.listdir(images_folder):
            if filename.startswith('image_'):
                file_path = os.path.join(images_folder, filename)
                os.remove(file_path)
                print(f"Removed: {filename}")
                found = True
        
        if found:
            print("Successfully cleared all image_ files")
        else:
            print("No image_ files found to clear")
    except Exception as e:
        print(f"Error clearing images: {e}")


def main():
    """Run administrative tasks."""
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'backend.settings')
    try:
        from django.core.management import execute_from_command_line
    except ImportError as exc:
        raise ImportError(
            "Couldn't import Django. Are you sure it's installed and "
            "available on your PYTHONPATH environment variable? Did you "
            "forget to activate a virtual environment?"
        ) from exc

    # Clear images if runserver command is used
    if len(sys.argv) > 1 and sys.argv[1] == 'runserver':
        print("Running server - cleaning up image files...")
        clear_images()

    execute_from_command_line(sys.argv)


if __name__ == '__main__':
    main()
