# Passer
This project began as a final thesis of my bachelor studies at FEI STU, Bratislava. It deals with the problem outside the password manager's ecosystem. The goal is to simplify user's access to his items inside the password manager on a foreign device.

Outcome of this thesis is a password manager app named **Passer**. The above mentioned foreign device doesn't have the Passer app. Passer offers a solution here. It is user-friendly and time-efficient while maintaining security protocols.

Passer consists of three elements:
1. iOS app
2. Backend server
3. Website

### iOS app
This is the main app for users that can create, store and access their passwords. Then send them with **Outsider** (which is one of the Passer features) to access them on a device without Passer. 

You can download and try the app yourself by downloading the *iOS - Passer App* folder
- Open it in XCode
- Plug any iPhone (5S or later)
- Resolve certificates and trust settings
- Compile the project by pressing Cmd + R

### Backend
Check out [Passer - Backend](https://github.com/petercurikjr/passer-backend).

### Website
Items sent with **Outsider** are accessible on the server for two minutes. You can access them on the website by entering a correct one-time verification. Either by entering a six digit code generated in the iOS **Passer** app, or by scanning a website's QR code, also with **Passer** app. After successful verification, selected items sent with **Outsider** are accessible.

Try it yourself: [Passer - Website](https://passer.netlify.app).
