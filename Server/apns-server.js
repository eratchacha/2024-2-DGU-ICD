const express = require('express');
const apn = require('node-apn');

const app = express();
app.use(express.json());


const apnProvider = new apn.Provider({
  token: {
    key: "",  // APNs 인증 키 경로
    keyId: "",               // Apple Developer에서 발급된 인증키 ID
    teamId: ""              // Apple Developer에서 확인한 Team ID
  },
  production: false  // 개발 중일 때는 false, 배포 시에는 true
});

// 메시지 수신 및 디바이스 B로 푸시 알림 전송
app.post('/send-message', (req, res) => {
  const { message } = req.body;
  const deviceToken = "";  // deviceToken 설정


  let notification = new apn.Notification();
  notification.topic = "chacha.Push-Notification";  // 앱의 번들 ID 
  notification.alert = message;
  notification.sound = "default";

  apnProvider.send(notification, deviceToken).then(result => {
    console.log("Push Notification Result: ", result);

    // APNs 응답에 대한 세부 사항 출력
    // result.failed.forEach((failure) => {
    //   console.error(`Failed to send notification to ${failure.device}:`);
    //   console.error(`Status: ${failure.status}`);
    //   console.error(`Reason: ${failure.response.reason}`);
    // });

    res.send("Message sent to device B");
  }).catch(err => {
    console.error("Error sending push notification: ", err);
    res.status(500).send("Error sending push notification");
  });
});


const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
