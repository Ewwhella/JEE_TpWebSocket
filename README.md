Rendu TP WebSocket par CHAABANE Zeineb, THOMAS Meven, PILLOT Pierre et GADELLE Ella

# Rendu TP WebSocket

## **Aperçu du projet**

Ce TP consiste à développer une application de chat en temps réel en utilisant **WebSocket**, **JSP**, et **Java**. L’objectif est de permettre à plusieurs utilisateurs de discuter via une interface web en temps réel. Le projet repose sur une interaction entre une page JSP, un serveur WebSocket, et un client WebSocket côté navigateur. Le serveur gère les connexions et la diffusion des messages entre les utilisateurs.

---

## **Fonctionnement du projet**

### **1. Page de Login**

La première étape consiste à permettre à l'utilisateur de saisir son nom d'utilisateur avant de rejoindre le chat. Le nom d'utilisateur est transmis à la page **`chat.jsp`** via l'URL, où il sera récupéré et utilisé dans le chat.

- **login.jsp** : Contient un formulaire qui permet à l'utilisateur de saisir un nom d'utilisateur. Ce formulaire redirige vers **`chat.jsp`**, avec le nom d'utilisateur passé comme paramètre dans l'URL (exemple : `http://localhost:8080/websocket_war/chat.jsp?username=Stan`).

### **2. WebSocket pour le Chat en Temps Réel**

Une fois connecté via **`chat.jsp`**, l'utilisateur est en mesure d'envoyer et de recevoir des messages en temps réel grâce à **WebSocket**.

- **WebSocket** : Le projet utilise le serveur WebSocket pour gérer les connexions entre les utilisateurs et la diffusion des messages. Lorsque l'utilisateur envoie un message, il est envoyé via WebSocket au serveur, qui le relaye ensuite à tous les autres utilisateurs connectés.
- **Backend (ServerEndpoint)** : La classe `ChatEndpoint` gère la communication WebSocket avec les utilisateurs. Elle utilise l'annotation `@ServerEndpoint("/chat")` pour définir le point d'accès du WebSocket.

Le serveur fonctionne de la manière suivante :
1. Lorsqu'un utilisateur se connecte, la méthode `@OnOpen` est appelée.
2. Lorsqu'un message est reçu, il est diffusé à tous les utilisateurs connectés via la méthode `@OnMessage`.
3. Lorsqu'un utilisateur se déconnecte, la méthode `@OnClose` est appelée pour nettoyer la connexion.

**Affichage des message dans (`ChatEndpoint.java`)** :
```java
@OnMessage
public void onMessage(String message, Session session) {
    System.out.println("Message received: " + message);
    for (ChatEndpoint endpoint : chatEndpoints) {
        synchronized (endpoint) {
            try {
                endpoint.session.getBasicRemote().sendText(message);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}

```

### **3. Frontend (chat.jsp)**

La page **`chat.jsp`** contient l'interface utilisateur pour afficher et envoyer des messages via WebSocket.

- **HTML** : La page contient un champ de saisie pour taper des messages et un bouton pour les envoyer. Les messages sont affichés dans un `div` dédié.
- **JavaScript** : Le JavaScript gère la connexion WebSocket, l'envoi de messages, et l'affichage des messages reçus.

Voici le code script dans **`chat.jsp`** :
```javascript
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
```

---

## **Conclusion**

Ce TP permet de comprendre les bases de l'utilisation de **WebSocket** pour la communication bidirectionnelle en temps réel dans une application web. Il met en pratique la séparation de la logique de gestion des messages (via le serveur WebSocket) et de l'interface utilisateur (via JSP et JavaScript). Grâce à l'implémentation de **WebSocket**, ce projet démontre comment gérer des connexions multiples et la diffusion de messages en temps réel, ce qui est essentiel pour les applications modernes telles que les systèmes de messagerie ou les notifications en direct.

Le projet fonctionne correctement en mode multi-utilisateurs grâce à la gestion des connexions WebSocket. En ouvrant plusieurs fenêtres de navigateur, chaque utilisateur peut se connecter au chat et échanger des messages en temps réel. Les messages envoyés par un utilisateur sont immédiatement visibles dans toutes les autres fenêtres ouvertes, ce qui simule parfaitement un chat en ligne entre plusieurs participants. La communication est fluide et les connexions sont gérées de manière stable, confirmant que l'application fonctionne comme prévu avec plusieurs utilisateurs simultanés.