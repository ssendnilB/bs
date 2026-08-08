SMITH ON YOUR PHONE — START HERE
=================================

You got this script from the public repo:
  https://github.com/ssendnilB/bs  (file: phone-setup.sh)

DO IT IN THIS ORDER (one step at a time):

STEP 1 — FINISH THE GRAPHEEENOS WIZARD
  * Connect to your Wi-Fi.
  * Skip Google / Play services when offered.
  * If you want the phone to talk to you: turn on TalkBack (accessibility).
  * Finish until you see the home screen.

STEP 2 — INSTALL F-DROID (the app shop, no Google needed)
  * Open Vanadium (the green-shield browser).
  * Go to:  f-droid.org
  * Tap Download F-Droid -> Install.
  * Open F-Droid. Tap Download at the bottom to refresh the app list.

STEP 3 — INSTALL TERMUX + TERMUX:API
  * In F-Droid search for:  Termux        -> Install
  * In F-Droid search for:  Termux:API    -> Install  (the camera's helper)

STEP 4 — RUN THE SETUP SCRIPT
  * Open Termux (black screen). Tap the screen to bring up the keyboard.
  * Type this EXACT line, then press ENTER:
      curl -fsSL https://raw.githubusercontent.com/ssendnilB/bs/main/phone-setup.sh | bash
  * When asked to allow storage, tap ALLOW.
  * Let it run. When you see "SMITH IS ON YOUR PHONE" — you're done.

STEP 5 — TALK TO SMITH
  * Type:  opencode     then press ENTER  (starts the agent)
  * To TALK instead of type: tap the MIC button on Gboard and speak.
  * To take a photo (your eyes): type  see   then press ENTER
      - It saves a photo and prints its name.
      - Then tell the agent: "look at the photo"

NEED HELP? Paste the last messages from Termux into a text file,
save it to the pCloud folder, and the Deck will read it.
