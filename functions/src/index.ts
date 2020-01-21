import * as functions from 'firebase-functions';

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

function getRandomInt(from: number, to: number) {
    const min = Math.ceil(from);
    const max = Math.floor(to);
    return Math.floor(Math.random() * (max-min) + min);
}

exports.addExperimentInfo = functions.firestore.document("users/{userId}").onCreate((snapshot, context) => {
    const randomGroup = getRandomInt(0, 2);
    console.log("random group: " + randomGroup);
})