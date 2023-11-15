// The Cloud Functions for Firebase SDK to create Cloud Functions and set up triggers.
const functions = require('firebase-functions');

// The Firebase Admin SDK to access Firestore.
const admin = require('firebase-admin');
admin.initializeApp();

// Take the text parameter passed to this HTTP endpoint and insert it into
// Firestore under the path /messages/:documentId/original
exports.addMessage = functions.https.onRequest(async (req, res) => {
  // Grab the text parameter.
  const original = req.query.text;
  // Push the new message into Firestore using the Firebase Admin SDK.
  const writeResult = await admin.firestore().collection('messages').add({original: original});
  // Send back a message that we've successfully written the message
  res.json({result: `Message with ID: ${writeResult.id} added.`});
});

// Listens for new messages added to /messages/:documentId/original and creates an
// uppercase version of the message to /messages/:documentId/uppercase
exports.makeUppercase = functions.firestore.document('/Posts/{documentId}')
.onCreate(
  async (snapshot, context) => {
      
      functions.logger.log('Running noti func');
    // Notification details.
    //const text = snapshot.data().username;
      username = ""
      const docId = context.params.documentId;
      userID = docId.split("(",2)[1]
      userID = userID.split(")")[0]
      functions.logger.log("user id", userID)
      payload = {
      "notification": {
        "title": "RealMusic",
        "body":  "Your friend " + username + "just posted!"
          //text ? (text.length <= 100 ? text : text.substring(0, 97) + '...') : '',
        //icon: snapshot.data().profilePicUrl || '/images/profile_placeholder.png',
        //click_action: `https://${process.env.GCLOUD_PROJECT}.firebaseapp.com`,
      }
    };

    // Get the list of device tokens.
    const allTokens = await admin.firestore().collection('DeviceTokens').get();
    functions.logger.log("length ",allTokens.size)
      if (allTokens.size > 0) {  // allTokens is a QuerySnapshot
          const tokens = allTokens.docs.map(tokenDoc => tokenDoc.data());
          functions.logger.log("tokens size", tokens.length)
          functions.logger.log("print allTokens", allTokens)
          functions.logger.log("print tokens", tokens)
          
          let justTokens = []
          
          for (var i = 0; i < tokens.length; i++) {
              functions.logger.log("just  tokens", justTokens)
              functions.logger.log("check for friends for this user:", tokens[i]["uid"])
              
              if (tokens[i]["uid"] == userID) {
                  functions.logger.log("this is the user that made the post", userID," ", tokens[i]["username"])
                  username = tokens[i]["username"] + " "
                  payload = {
                  "notification": {
                    "title": "RealMusic",
                    "body": "Your friend " + username + "just posted!"
                      //text ? (text.length <= 100 ? text : text.substring(0, 97) + '...') : '',
                    //icon: snapshot.data().profilePicUrl || '/images/profile_placeholder.png',
                    //click_action: `https://${process.env.GCLOUD_PROJECT}.firebaseapp.com`,
                  }
                };

              } else {
                  let friendsWithPoster = false
                  allfriends = await admin.firestore().collection('Users').doc(tokens[i]["uid"]).collection("Friends").get();
                  functions.logger.log("length of their friends",allfriends.size)
                  if (allfriends.size > 0) {
                      friends = allfriends.docs.map(tokenDoc => tokenDoc.data());
                      
                      for (var x = 0; x < friends.length; x++) {
                          functions.logger.log(allfriends.docs[x].id)
                          let friendID = allfriends.docs[x].id
                          if (friendID == userID) {
                              friendsWithPoster = true
                          }
                      }
                      
                      if (friendsWithPoster == true) {
                          functions.logger.log("send this user a noti")
                          justTokens.push(tokens[i]["token"])

                      }

                  }
                  //justTokens.push(tokens[i]["token"])
              }
          }
          functions.logger.log("just  tokens", justTokens)

          await admin.messaging().sendToDevice(justTokens, payload)
          .then((response) => {
                    // Response is a message ID string.
                    console.log('Successfully sent message:', response);
                    functions.logger.log('Successfully sent message:', response)
                  })
                  .catch((error) => {
                      functions.logger.log('Error sending message:', response)

                    console.log('Error sending message:', error);
                  });
          functions.logger.log('Notifications have been sent and tokens cleaned up.');
          //const response = await admin.messaging().sendToDevice(tokens, payload);
          //await cleanupTokens(response, tokens);
          
          }
      // Send notifications to all tokens.
    
      functions.logger.log("all done")
    
  });

exports.sendReactionAlert = functions.firestore.document('/Posts/{documentId}/Reactions/{reactionId}')
.onCreate(
  async (snapshot, context) => {
      
      functions.logger.log('Running noti func');
    // Notification details.
    //const text = snapshot.data().username;
      const docId = context.params.documentId;
      const reaction = snapshot.data();
      userID = docId.split("(",2)[1]
      userID = userID.split(")")[0]
      functions.logger.log("user id", userID)
      functions.logger.log("reaction user", reaction["username"])
      functions.logger.log("reaction emoji", reaction["emoji"])

      payload = {
      "notification": {
        "title": "RealMusic",
        "body" : reaction["username"] + " reacted to your post"
          //text ? (text.length <= 100 ? text : text.substring(0, 97) + '...') : '',
        //icon: snapshot.data().profilePicUrl || '/images/profile_placeholder.png',
        //click_action: `https://${process.env.GCLOUD_PROJECT}.firebaseapp.com`,
      }
    };

    // Get the list of device tokens.
    const allTokens = await admin.firestore().collection('DeviceTokens').get();
    functions.logger.log("length ",allTokens.size)
      if (allTokens.size > 0) {  // allTokens is a QuerySnapshot
          const tokens = allTokens.docs.map(tokenDoc => tokenDoc.data());
          functions.logger.log("tokens size", tokens.length)
          functions.logger.log("print allTokens", allTokens)
          functions.logger.log("print tokens", tokens)
          
          let justTokens = []
          
          for (var i = 0; i < tokens.length; i++) {
              functions.logger.log("just  tokens", justTokens)
              if (tokens[i]["uid"] == userID) {
                  functions.logger.log("this is the user that made the post", userID," ", tokens[i]["username"])
                  justTokens.push(tokens[i]["token"])
               

              }
          }
          functions.logger.log("just  tokens", justTokens)

          await admin.messaging().sendToDevice(justTokens, payload)
          .then((response) => {
                    // Response is a message ID string.
                    console.log('Successfully sent message:', response);
                    functions.logger.log('Successfully sent message:', response)
                  })
                  .catch((error) => {
                      functions.logger.log('Error sending message:', response)

                    console.log('Error sending message:', error);
                  });
          functions.logger.log('Notifications have been sent and tokens cleaned up.');
          //const response = await admin.messaging().sendToDevice(tokens, payload);
          //await cleanupTokens(response, tokens);
          
          }
      // Send notifications to all tokens.
    
      functions.logger.log("all done")
    
  });


// Requests permissions to show notifications.
async function requestNotificationsPermissions() {
  console.log('Requesting notifications permission...');
  const permission = await Notification.requestPermission();
  
  if (permission === 'granted') {
    console.log('Notification permission granted.');
    // Notification permission granted.
    await saveMessagingDeviceToken();
  } else {
    console.log('Unable to get permission to notify.');
  }
}

// Saves the messaging device token to Cloud Firestore.
async function saveMessagingDeviceToken() {
  try {
    const currentToken = await getToken(getMessaging());
    if (currentToken) {
      console.log('Got FCM device token:', currentToken);
      // Saving the Device Token to Cloud Firestore.
      const tokenRef = doc(getFirestore(), 'fcmTokens', currentToken);
      await setDoc(tokenRef, { uid: getAuth().currentUser.uid });

      // This will fire when a message is received while the app is in the foreground.
      // When the app is in the background, firebase-messaging-sw.js will receive the message instead.
      onMessage(getMessaging(), (message) => {
        console.log(
          'New foreground notification from Firebase Messaging!',
          message.notification
        );
      });
    } else {
      // Need to request permissions to show notifications.
      requestNotificationsPermissions();
    }
  } catch(error) {
    console.error('Unable to get messaging token.', error);
 
  };
}
