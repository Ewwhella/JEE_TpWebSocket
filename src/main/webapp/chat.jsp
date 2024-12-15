<%--
  Created by IntelliJ IDEA.
  User: CYTech Student
  Date: 14/12/2024
  Time: 11:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>Chat Room</title>
</head>
<body>
<h1>Welcome, <%= request.getParameter("username") %></h1>
<div id="messages" style="border: 1px solid #ccc; height: 300px; overflow-y: scroll;"></div>
<input type="text" id="message" placeholder="Type a message">
<button onclick="sendMessage()">Send</button>

<script>
  let websocket = new WebSocket("ws://localhost:8080/websocket_war/chat");
  websocket.onmessage = function(event) {
    const messagesDiv = document.getElementById("messages");
    messagesDiv.innerHTML += "<div>" + event.data + "</div>";
  };

  function sendMessage() {
    const messageInput = document.getElementById("message");
    const message = "<%= request.getParameter("username") %>: " + messageInput.value;
    websocket.send(message);
    messageInput.value = "";
  }
</script>
</body>
</html>

