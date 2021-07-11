<script>
  import {db} from "../services/firebase";
  import ChatNav from "./ChatNav.svelte";

  let site, identity;

  const servers = {
    iceServers: [
      {
        urls: [
          "stun:stun1.l.google.com:19302",
          "stun:stun2.l.google.com:19302",
        ],
      },
    ],
    iceCandidatePoolSize: 10,
  };

  const pc = new RTCPeerConnection(servers);
  let localStream = null;
  let remoteStream = null;

  let webcamButtonDisabled = false;
  let callButtonDisabled = true;
  let answerButtonDisabled = true;
  let hangupButtonDisabled = true;
  let webcamVideo;
  let remoteVideo;
  let callInput;

  // 1. Setup media sources

  const webcamButtonOnclick = async () => {
    localStream = await navigator.mediaDevices.getUserMedia({
      video: true,
      audio: true,
    });
    remoteStream = new MediaStream();

    // Push tracks from local stream to peer connection
    localStream.getTracks().forEach(track => {
      pc.addTrack(track, localStream);
    });

    // Pull tracks from remote stream, add to video stream
    pc.ontrack = event => {
      event.streams[0].getTracks().forEach(track => {
        remoteStream.addTrack(track);
      });
    };

    webcamVideo.srcObject = localStream;
    remoteVideo.srcObject = remoteStream;

    callButtonDisabled = false;
    answerButtonDisabled = false;
    webcamButtonDisabled = true;
  };

  // 2. Create an offer
  const callButtonOnclick = async () => {
    // Reference Firestore collections for signaling
    const callDoc = db.collection("calls").doc();
    const offerCandidates = callDoc.collection("offerCandidates");
    const answerCandidates = callDoc.collection("answerCandidates");

    callInput.value = callDoc.id;

    // Get candidates for caller, save to db
    pc.onicecandidate = event => {
      event.candidate && offerCandidates.add(event.candidate.toJSON());
    };

    // Create offer
    const offerDescription = await pc.createOffer();
    await pc.setLocalDescription(offerDescription);

    const offer = {
      sdp: offerDescription.sdp,
      type: offerDescription.type,
    };

    await callDoc.set({offer});

    // Listen for remote answer
    callDoc.onSnapshot(snapshot => {
      const data = snapshot.data();
      if (!pc.currentRemoteDescription && data["answer"]) {
        const answerDescription = new RTCSessionDescription(data.answer);
        pc.setRemoteDescription(answerDescription);
      }
    });

    // When answered, add candidate to peer connection
    answerCandidates.onSnapshot(snapshot => {
      snapshot.docChanges().forEach(change => {
        if (change.type === "added") {
          const candidate = new RTCIceCandidate(change.doc.data());
          pc.addIceCandidate(candidate);
        }
      });
    });

    hangupButtonDisabled = false;
  };

  // 3. Answer the call with the unique ID
  const answerButtonOnclick = async () => {
    const callId = callInput.value;
    const callDoc = db.collection("calls").doc(callId);
    const answerCandidates = callDoc.collection("answerCandidates");
    const offerCandidates = callDoc.collection("offerCandidates");

    pc.onicecandidate = event => {
      event.candidate && answerCandidates.add(event.candidate.toJSON());
    };

    const callData = (await callDoc.get()).data();

    const offerDescription = callData.offer;
    await pc.setRemoteDescription(new RTCSessionDescription(offerDescription));

    const answerDescription = await pc.createAnswer();
    await pc.setLocalDescription(answerDescription);

    const answer = {
      type: answerDescription.type,
      sdp: answerDescription.sdp,
    };

    await callDoc.update({answer});

    offerCandidates.onSnapshot(snapshot => {
      snapshot.docChanges().forEach(change => {
        console.log(change);
        if (change.type === "added") {
          let data = change.doc.data();
          pc.addIceCandidate(new RTCIceCandidate(data));
        }
      });
    });
  };
</script>

<div class="call">
  <ChatNav {site} {identity} />
  Call a friend ...
  <div class="videos">
    <div class="video">
      <h3>You</h3>
      <video bind:this={webcamVideo} autoplay playsinline
        ><track kind="captions" /></video
      >
    </div>
    <div class="video">
      <h3>Friend</h3>
      <video bind:this={remoteVideo} autoplay playsinline
        ><track kind="captions" /></video
      >
    </div>
  </div>
  <div class="controls">
    <button
      on:click={webcamButtonOnclick}
      disabled={webcamButtonDisabled}
      class="btn btn-a btn-sm">Start webcam</button
    >
    <button
      on:click={callButtonOnclick}
      disabled={callButtonDisabled}
      class="btn btn-sm">Create Call (offer)</button
    >
  </div>
  <div class="controls">
    <input id="callInput" bind:this={callInput} />
    <button
      on:click={answerButtonOnclick}
      class="btn btn-sm"
      disabled={answerButtonDisabled}>Answer</button
    >
  </div>
  <div class="controls">
    <button id="hangupButton" class="btn btn-sm" disabled={hangupButtonDisabled}
      >Hangup</button
    >
  </div>
</div>

<style>
  .call {
    margin: 1rem;
  }

  .videos {
    display: flex;
  }
  .video video {
    max-width: 180px;
  }
  .btn:disabled {
    color: rgba(16, 16, 16, 0.3);
    background-color: rgba(239, 239, 239, 0.3);
    border-color: rgba(118, 118, 118, 0.3);
  }
</style>
