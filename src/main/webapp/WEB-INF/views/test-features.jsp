<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>KSYK Features Testing Panel (JSTL)</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; background-color: #f4f4f9; }
        .container { max-width: 600px; margin: auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        .section { margin-bottom: 20px; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
        h3 { margin-top: 0; color: #333; }
        .input-group { margin-bottom: 10px; }
        input, select, textarea { padding: 8px; width: calc(100% - 20px); margin-top: 5px; border: 1px solid #ccc; border-radius: 4px; }
        button { padding: 10px 15px; background: #28a745; color: white; border: none; border-radius: 4px; cursor: pointer; }
        button:hover { background: #218838; }
        #responseLog { background: #333; color: #0f0; padding: 10px; border-radius: 5px; height: 100px; overflow-y: auto; font-family: monospace; }
        .flex-row { display: flex; gap: 10px; margin-bottom: 15px; }
        .flex-row div { flex: 1; }
    </style>
</head>
<body>

<div class="container">
    <h2 style="text-align: center;">🛠️ KSYK Features Testing Panel</h2>
    
    <div class="section">
        <h3>Server Response:</h3>
        <div id="responseLog">Waiting for action...</div>
    </div>

    <div class="flex-row">
        <div>
            <label>User ID:</label>
            <input type="number" id="userId" value="1">
        </div>
        <div>
            <label>CheatSheet ID:</label>
            <input type="number" id="cheatSheetId" value="1">
        </div>
    </div>

    <div class="section">
        <h3>⭐ 1. Favorite Feature</h3>
        <button onclick="toggleFavorite()">Toggle Favorite (Add/Remove)</button>
    </div>

    <div class="section">
        <h3>🌟 2. Star Rating</h3>
        <div class="input-group">
            <select id="stars">
                <option value="1">1 Star</option>
                <option value="2">2 Stars</option>
                <option value="3">3 Stars</option>
                <option value="4">4 Stars</option>
                <option value="5" selected>5 Stars</option>
            </select>
        </div>
        <button onclick="submitRating()">Submit Rating</button>
    </div>

    <div class="section">
        <h3>💬 3. Comment System</h3>
        <div class="input-group">
            <textarea id="commentContent" rows="3" placeholder="Write your comment here..."></textarea>
        </div>
        <div class="input-group">
            <input type="number" id="parentCommentId" placeholder="Parent Comment ID (Optional for Reply)">
        </div>
        <button onclick="postComment()">Post Comment / Reply</button>
    </div>

    <div class="section">
        <h3>👍 4. Reactions (Likes)</h3>
        
        <div style="margin-bottom: 15px;">
            <strong>CheatSheet Reaction:</strong>
            <button onclick="reactToSheet(true)" style="background: #007bff;">👍 Like Sheet</button>
            <button onclick="reactToSheet(false)" style="background: #dc3545;">👎 Dislike Sheet</button>
        </div>

        <div>
            <strong>Comment Reaction:</strong>
            <input type="number" id="targetCommentId" placeholder="Target Comment ID" style="width: 150px; display: inline-block;">
            <button onclick="reactToComment(true)" style="background: #007bff;">👍 Like</button>
            <button onclick="reactToComment(false)" style="background: #dc3545;">👎 Dislike</button>
        </div>
    </div>
</div>

<script>
    // 🌟 JSTL ရဲ့ c:url ကို သုံးပြီး Base API Path ကို ထုတ်ယူခြင်း
    // ဒီလိုရေးလိုက်တဲ့အတွက် http://localhost:8080/... လို့ ကိုယ်တိုင်ရိုက်စရာ မလိုတော့ပါဘူး
    const BASE_URL = "<c:url value='/api' />";

    async function callApi(endpoint, method, params) {
        const url = new URL(window.location.origin + BASE_URL + endpoint);
        Object.keys(params).forEach(key => {
            if(params[key] !== "") url.searchParams.append(key, params[key]);
        });

        try {
            const response = await fetch(url, { method: method });
            const resultText = await response.text();
            document.getElementById('responseLog').innerHTML = `> Status: ${response.status} <br>> Message: ${resultText}`;
        } catch (error) {
            document.getElementById('responseLog').innerHTML = `> Error: ${error.message}`;
        }
    }

    function getIds() {
        return {
            userId: document.getElementById('userId').value,
            cheatSheetId: document.getElementById('cheatSheetId').value
        };
    }

    function toggleFavorite() {
        callApi('/favorites/toggle', 'POST', getIds());
    }

    function submitRating() {
        const params = getIds();
        params.stars = document.getElementById('stars').value;
        callApi('/ratings/submit', 'POST', params);
    }

    function postComment() {
        const params = getIds();
        params.content = document.getElementById('commentContent').value;
        params.parentCommentId = document.getElementById('parentCommentId').value;
        callApi('/interactions/comment', 'POST', params); 
    }

    function reactToSheet(isLike) {
        const params = getIds();
        params.isLike = isLike;
        callApi('/interactions/sheet-reaction', 'POST', params); 
    }

    function reactToComment(isLike) {
        const params = {
            userId: document.getElementById('userId').value,
            commentId: document.getElementById('targetCommentId').value,
            isLike: isLike
        };
        callApi('/interactions/comment-reaction', 'POST', params); 
    }
</script>

</body>
</html>