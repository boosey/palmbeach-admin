const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.setAdminClaim = functions.https.onCall((data, context) =>{
  // if (context.auth.token.admin == true) {
  console.log("excuting set admin claim: ", data);
  admin
      .auth()
      .setCustomUserClaims(data, {admin: true});
  // }
  return "OK";
});

exports.clearAdminClaim = functions.https.onCall((data, context) =>{
  admin
      .auth()
      .setCustomUserClaims(data, null);
  return "OK";
});

exports.sendWelcomeEmail = functions.auth.user().onCreate((user) => {
  const db = admin.firestore();
  const docRef = db.collection("users").doc(user.uid);

  docRef.set({
    firstName: "",
    lastName: "",
  });
});
