<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${sheet.title}</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        body { background: radial-gradient(circle at 50% 50%, #fef3f6 0%, #e8dbe5 100%); min-height: 100vh; color: #1a1a1a; }
        .detail-container { max-width: 900px; margin: 60px auto; padding: 0 20px; }
        .sheet-title { font-size: 48px; font-weight: 800; color: #1a1a1a; display: inline-block; }
        .author-text { font-size: 22px; color: #555; font-weight: bold; margin-left: 10px; }
        .description-text { font-size: 18px; color: #333; margin-top: 25px; margin-bottom: 35px; line-height: 1.6; }
        
        .code-container-box { background: rgba(255, 255, 255, 0.45); backdrop-filter: blur(16px); -webkit-backdrop-filter: blur(16px); border: 1px solid rgba(255, 255, 255, 0.6); border-radius: 20px; padding: 25px 30px; margin-bottom: 35px; box-shadow: 0 15px 35px rgba(0, 0, 0, 0.05); }
        .plain-code-text { font-family: 'Courier New', Courier, monospace; font-size: 18px; line-height: 1.5; color: #1a1a1a; margin: 0; white-space: pre-wrap; word-break: break-all; }
        
        .tag-badge { background-color: rgba(255, 255, 255, 0.6); backdrop-filter: blur(5px); border: 1px solid rgba(255, 255, 255, 0.8); color: #333; padding: 8px 18px; border-radius: 20px; font-size: 14px; font-weight: bold; text-decoration: none; display: inline-block; transition: all 0.2s ease; }
        .tag-badge:hover { background-color: #1a1a1a; color: white; transform: translateY(-2px); }

        .interaction-bar { background: rgba(255, 255, 255, 0.45); backdrop-filter: blur(16px); -webkit-backdrop-filter: blur(16px); border: 1px solid rgba(255, 255, 255, 0.6); border-radius: 20px; padding: 15px 20px; margin-top: 30px; display: flex; align-items: center; gap: 15px; flex-wrap: wrap; box-shadow: 0 15px 35px rgba(0, 0, 0, 0.05); }
        .action-btn { background: rgba(255, 255, 255, 0.5); backdrop-filter: blur(5px); border: 1px solid rgba(255, 255, 255, 0.8); padding: 8px 15px; border-radius: 20px; font-weight: 600; color: #555; transition: 0.2s; }
        .action-btn:hover { background: #fff; transform: translateY(-2px); }
        
        .btn-heart:hover, .btn-heart.active { background: #fff0f1; color: #ff3366; border-color: #ff3366; }
        .btn-like:hover, .btn-like.active { background: #e0fbfc; color: #ff3366; border-color: #ff3366; }
        .btn-dislike:hover, .btn-dislike.active { background: #fae0e4; color: #d62828; border-color: #d62828; }

        .comment-section { margin-top: 50px; }
        .comment-box { background: rgba(255, 255, 255, 0.45); backdrop-filter: blur(16px); padding: 20px; border-radius: 20px; margin-bottom: 15px; border: 1px solid rgba(255, 255, 255, 0.6); box-shadow: 0 5px 15px rgba(0,0,0,0.02); }
        .reply-box { margin-left: 50px; border-left: 3px solid #ff3366; background: rgba(255, 255, 255, 0.3); }
        .comment-author { font-weight: bold; color: #1a1a1a; font-size: 15px; }
        .comment-text { margin-top: 8px; color: #333; font-size: 15px; line-height: 1.5; }
    </style>
</head>
<body>

    <jsp:include page="header.jsp" />

    <div class="container mt-4">
        <a href="javascript:history.back()" class="btn btn-outline-secondary mb-3">
            <i class="bi bi-arrow-left"></i> Back
        </a>
    </div>

    <div class="detail-container">
        
        <%-- Title & Author --%>
        <div>
            <h1 class="sheet-title">${sheet.title}</h1>
            <span class="author-text">by 
                <c:choose>
                    <c:when test="${sheet.author != null}">
                        <a href="${pageContext.request.contextPath}/profile/${sheet.author.id}" 
                            class="text-dark fw-bold text-decoration-none" 
                           style="border-bottom: 2px solid #ff3366; padding-bottom: 2px;">
                            <c:out value="${sheet.author.username}" />
                        </a>
                    </c:when>
                    <c:otherwise>
                        <span class="text-muted fw-normal">Unknown</span>
                    </c:otherwise>
                </c:choose>
                <span class="text-muted ms-3" style="font-size: 16px;"><i class="bi bi-eye"></i> ${sheet.viewCount != null ? sheet.viewCount : 0} Views</span>
            </span>
        </div>
 
        <%-- Description Section --%>
        <p class="description-text">
            ${sheet.description}
        </p>

        <div class="code-container-box">
            <pre class="plain-code-text"><c:out value="${sheet.content}" /></pre>
        </div>

        <div class="d-flex flex-wrap gap-2">
            <c:forEach items="${sheet.tags}" var="tag">
                <a href="${pageContext.request.contextPath}/cheatsheet/tag/${tag.id}" class="tag-badge">#${tag.name}</a>
            </c:forEach>
        </div>

        <%-- INTERACTION BAR (AJAX Seamless) --%>
        <div class="interaction-bar">
            <c:choose>
                <c:when test="${not empty sessionScope.currentUser}">
                    <button type="button" onclick="toggleFavJS(this)" class="action-btn btn-heart ${isFavorited ? 'active' : ''}">
                        <i class="${isFavorited ? 'fa-solid' : 'fa-regular'} fa-heart"></i> 
                        <span id="favText">${isFavorited ? 'Saved' : 'Save'}</span>
                    </button>

                    <div class="vr mx-2"></div> 

                    <button type="button" id="sheetLikeBtn" onclick="reactSheetJS(true)" class="action-btn btn-like ${userSheetLike == true ? 'active' : ''}">
                        <i class="fa-solid fa-thumbs-up"></i> <span id="sheetLikeCount">${sheetLikes != null ? sheetLikes : 0}</span>
                    </button>
                    <button type="button" id="sheetDislikeBtn" onclick="reactSheetJS(false)" class="action-btn btn-dislike ${userSheetLike == false ? 'active' : ''}">
                        <i class="fa-solid fa-thumbs-down"></i> <span id="sheetDislikeCount">${sheetDislikes != null ? sheetDislikes : 0}</span>
                    </button>

                    <div class="vr mx-2"></div> 
                    
                    <div class="d-flex align-items-center">
                        <span class="me-3 fw-bold text-dark"><i class="fa-solid fa-star text-warning"></i> ${avgRating > 0 ? avgRating : '0.0'}</span>
                        <span class="text-muted me-2" style="font-size: 14px;">Your Rate:</span>
                        
                        <div class="star-rating me-3" style="font-size: 20px; cursor: pointer;">
                            <i class="fa-star star-icon ${userRating >= 1 ? 'fa-solid text-warning' : 'fa-regular text-muted'}" data-value="1"></i>
                            <i class="fa-star star-icon ${userRating >= 2 ? 'fa-solid text-warning' : 'fa-regular text-muted'}" data-value="2"></i>
                            <i class="fa-star star-icon ${userRating >= 3 ? 'fa-solid text-warning' : 'fa-regular text-muted'}" data-value="3"></i>
                            <i class="fa-star star-icon ${userRating >= 4 ? 'fa-solid text-warning' : 'fa-regular text-muted'}" data-value="4"></i>
                            <i class="fa-star star-icon ${userRating >= 5 ? 'fa-solid text-warning' : 'fa-regular text-muted'}" data-value="5"></i>
                        </div>
                        <input type="hidden" id="ratingSelect" value="${userRating > 0 ? userRating : 0}">
                        
                        <button type="button" id="rateSubmitBtn" onclick="submitRatingJS()" class="btn btn-sm btn-outline-warning text-dark fw-bold">Undo</button>
                    </div>

                    <div class="vr mx-2"></div>

                    <button type="button" id="shareBtn" onclick="shareCheatsheetJS()" class="btn btn-sm btn-primary fw-bold px-3 me-2">
                        <i class="bi bi-share-fill me-1"></i> <span id="shareBtnText">Share</span>
                    </button>
                    
                    <button type="button" class="action-btn text-danger ms-auto" data-bs-toggle="modal" data-bs-target="#reportSheetModal">
                        <i class="bi bi-flag"></i> Report
                    </button>
                </c:when>

                <c:otherwise>
                    <span class="text-muted"><i class="bi bi-info-circle text-primary"></i> Please <strong><a href="${pageContext.request.contextPath}/login" class="text-decoration-none">Login</a></strong> to interact.</span>
                    <span class="ms-auto fw-bold text-dark"><i class="fa-solid fa-star text-warning"></i> ${avgRating > 0 ? avgRating : '0.0'}</span>
                </c:otherwise>
            </c:choose>
        </div>

        <%-- COMMENTS SECTION --%>
        <div class="comment-section">
            <h3 class="mb-4"><i class="bi bi-chat-dots-fill text-primary"></i> Comments</h3>

            <c:choose>
                <c:when test="${not empty sessionScope.currentUser}">
                    <div class="mb-5 p-4 rounded border" style="background: rgba(255, 255, 255, 0.45); backdrop-filter: blur(16px); border-color: rgba(255, 255, 255, 0.6) !important;">
                        <textarea id="mainCommentContent" class="form-control mb-3" rows="3" placeholder="Share your thoughts..."></textarea>
                        <button type="button" onclick="postMainCommentJS()" class="btn btn-primary px-4 fw-bold"><i class="bi bi-send"></i> Post Comment</button>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-secondary mb-5">Please <strong><a href="${pageContext.request.contextPath}/login" class="text-decoration-none">Login</a></strong> to join the conversation.</div>
                </c:otherwise>
            </c:choose>

            <div id="commentsWrapper">
                <c:if test="${empty commentsList}">
                    <p id="noCommentsMsg" class="text-muted text-center py-4">No comments yet. Be the first to start the conversation!</p>
                </c:if>

                <c:forEach items="${commentsList}" var="comment">
                    <c:if test="${comment.parentComment == null}">
                        
                        <div id="commentThread_${comment.id}">
                            <div class="comment-box">
                                <div class="comment-author"><i class="fa-solid fa-circle-user text-primary me-1"></i> ${comment.user.username}</div>
                                <div class="comment-text">${comment.content}</div>
                                
                                <div class="mt-2">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.currentUser}">
                                            <button type="button" id="cLikeBtn_${comment.id}" onclick="reactCommentJS(${comment.id}, true)" class="btn btn-sm btn-link text-decoration-none p-0 me-2 ${comment.currentUserReaction == true ? 'text-primary fw-bold' : 'text-muted'}"><i class="bi bi-hand-thumbs-up-fill"></i> <span id="cLikeCount_${comment.id}">${comment.likeCount}</span></button>
                                            <button type="button" id="cDislikeBtn_${comment.id}" onclick="reactCommentJS(${comment.id}, false)" class="btn btn-sm btn-link text-decoration-none p-0 me-3 ${comment.currentUserReaction == false ? 'text-danger fw-bold' : 'text-muted'}"><i class="bi bi-hand-thumbs-down-fill"></i> <span id="cDislikeCount_${comment.id}">${comment.dislikeCount}</span></button>
                                            <button type="button" class="btn btn-sm btn-link text-decoration-none p-0 text-muted" onclick="document.getElementById('replyForm_${comment.id}').style.display='block';"><i class="bi bi-reply"></i> Reply</button>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted me-3" style="font-size: 13px;"><i class="bi bi-hand-thumbs-up"></i> ${comment.likeCount}</span>
                                            <span class="text-muted me-3" style="font-size: 13px;"><i class="bi bi-hand-thumbs-down"></i> ${comment.dislikeCount}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            
                            <%-- Replies Container --%>
                            <div id="repliesContainer_${comment.id}">
                                <c:forEach items="${commentsList}" var="reply">
                                    <c:if test="${reply.parentComment != null && reply.parentComment.id == comment.id}">
                                        <div class="comment-box reply-box">
                                            <div class="comment-author"><i class="fa-solid fa-reply text-info me-1"></i> ${reply.user.username} <span class="text-muted fw-normal" style="font-size:12px;">replied to ${comment.user.username}</span></div>
                                            <div class="comment-text">${reply.content}</div>

                                            <div class="mt-2">
                                                <c:if test="${not empty sessionScope.currentUser}">
                                                    <button type="button" id="cLikeBtn_${reply.id}" onclick="reactCommentJS(${reply.id}, true)" class="btn btn-sm btn-link text-decoration-none p-0 me-2 ${reply.currentUserReaction == true ? 'text-primary fw-bold' : 'text-muted'}"><i class="bi bi-hand-thumbs-up-fill"></i> <span id="cLikeCount_${reply.id}">${reply.likeCount}</span></button>
                                                    <button type="button" id="cDislikeBtn_${reply.id}" onclick="reactCommentJS(${reply.id}, false)" class="btn btn-sm btn-link text-decoration-none p-0 me-3 ${reply.currentUserReaction == false ? 'text-danger fw-bold' : 'text-muted'}"><i class="bi bi-hand-thumbs-down-fill"></i> <span id="cDislikeCount_${reply.id}">${reply.dislikeCount}</span></button>
                                                    <button type="button" class="btn btn-sm btn-link text-decoration-none p-0 text-muted" onclick="document.getElementById('replyForm_${comment.id}').style.display='block'; document.getElementById('replyInput_${comment.id}').value='@${reply.user.username} '"><i class="bi bi-reply"></i> Reply</button>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </div>

                            <%-- Reply Input Form --%>
                            <c:if test="${not empty sessionScope.currentUser}">
                                <div id="replyForm_${comment.id}" class="mt-3 p-3 rounded border" style="display:none; background: rgba(255, 255, 255, 0.45); backdrop-filter: blur(16px); border-color: rgba(255, 255, 255, 0.6) !important;">
                                    <div class="input-group">
                                        <input type="text" id="replyInput_${comment.id}" class="form-control" placeholder="Replying...">
                                        <button class="btn btn-primary fw-bold" type="button" onclick="postReplyJS(${comment.id})">Send</button>
                                        <button class="btn btn-secondary" type="button" onclick="document.getElementById('replyForm_${comment.id}').style.display='none'">Cancel</button>
                                    </div>
                                </div>
                            </c:if>

                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <%-- JAVASCRIPT FOR SEAMLESS UI --%>
    <script>
        const currentUserId = parseInt('${sessionScope.currentUser != null ? sessionScope.currentUser.id : 0}') || 0;
        const currentUserName = "${sessionScope.currentUser != null ? sessionScope.currentUser.username : 'Guest'}";
        const currentSheetId = parseInt('${sheet.id}') || 0;
        const contextPath = '${pageContext.request.contextPath}';

        function checkLogin() {
            if (currentUserId === 0) { alert("Please login first!"); return false; }
            return true;
        }

        function toggleFavJS(btn) {
            if (!checkLogin()) return;
            fetch(contextPath + '/favorite/toggle', {method: 'POST', body: new URLSearchParams({userId: currentUserId, cheatSheetId: currentSheetId})})
            .then(() => {
                btn.classList.toggle('active');
                let icon = btn.querySelector('i'); let text = btn.querySelector('span');
                if(btn.classList.contains('active')){
                    icon.classList.replace('fa-regular', 'fa-solid'); text.innerText = "Saved";
                } else {
                    icon.classList.replace('fa-solid', 'fa-regular'); text.innerText = "Save";
                }
            }).catch(err => alert("Error: " + err.message));
        }

        function reactSheetJS(isLike) {
            if (!checkLogin()) return;
            fetch(contextPath + '/interaction/react-sheet', {method: 'POST', body: new URLSearchParams({userId: currentUserId, cheatSheetId: currentSheetId, isLike: isLike})})
            .then(res => { if(!res.ok) throw new Error("Server error"); return res.json(); })
            .then(data => {
                document.getElementById('sheetLikeCount').innerText = data.likes;
                document.getElementById('sheetDislikeCount').innerText = data.dislikes;
                let lBtn = document.getElementById('sheetLikeBtn'); let dBtn = document.getElementById('sheetDislikeBtn');
                if (isLike) { lBtn.classList.add('active'); dBtn.classList.remove('active'); } 
                else { dBtn.classList.add('active'); lBtn.classList.remove('active'); }
            }).catch(err => alert("Action failed: " + err.message));
        }

        function reactCommentJS(commentId, isLike) {
            if (!checkLogin()) return;
            fetch(contextPath + '/interaction/react-comment', {method: 'POST', body: new URLSearchParams({userId: currentUserId, commentId: commentId, isLike: isLike})})
            .then(res => { if(!res.ok) throw new Error("Server error"); return res.json(); })
            .then(data => {
                document.getElementById('cLikeCount_' + commentId).innerText = data.likes;
                document.getElementById('cDislikeCount_' + commentId).innerText = data.dislikes;
                let lBtn = document.getElementById('cLikeBtn_' + commentId); let dBtn = document.getElementById('cDislikeBtn_' + commentId);
                if (isLike) {
                    lBtn.classList.add('text-primary', 'fw-bold'); lBtn.classList.remove('text-muted', 'text-danger');
                    dBtn.classList.remove('text-danger', 'fw-bold'); dBtn.classList.add('text-muted');
                } else {
                    dBtn.classList.add('text-danger', 'fw-bold'); dBtn.classList.remove('text-muted', 'text-primary');
                    lBtn.classList.remove('text-primary', 'fw-bold'); lBtn.classList.add('text-muted');
                }
            }).catch(err => alert("Action failed: " + err.message));
        }

        function submitRatingJS(ratingValue) {
            if (!checkLogin()) return;
            if(!ratingValue) {
                ratingValue = document.getElementById("ratingSelect").value;
            }
            if(ratingValue == 0) ratingValue = null; // for undo
            fetch(contextPath + '/rating/submit', {method: 'POST', body: new URLSearchParams({userId: currentUserId, cheatSheetId: currentSheetId, stars: ratingValue})})
            .then(() => {
                let btn = document.getElementById('rateSubmitBtn');
                let originalText = btn.innerText;
                btn.innerText = "Saved!"; btn.classList.replace('btn-outline-warning', 'btn-success');
                setTimeout(() => { btn.innerText = originalText; btn.classList.replace('btn-success', 'btn-outline-warning'); }, 2000);
            }).catch(err => alert("Error: " + err.message));
        }
        
        function shareCheatsheetJS() {
            if (!checkLogin()) return; 
            fetch(contextPath + '/interaction/share-post', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: new URLSearchParams({ cheatSheetId: currentSheetId })
            })
            .then(res => {
                if (res.status === 401) { alert("Please login first to share this post!"); return; }
                if (!res.ok) { return res.json().then(errData => { throw new Error(errData.message); }); }
                return res.json();
            })
            .then(data => {
                const shareBtn = document.getElementById('shareBtn');
                const shareText = document.getElementById('shareBtnText');
                shareBtn.classList.replace('btn-primary', 'btn-success');
                shareText.innerText = "Shared!";
                setTimeout(() => {
                    shareBtn.classList.replace('btn-success', 'btn-primary');
                    shareText.innerText = "Share";
                }, 2500);
            })
            .catch(err => alert(err.message));
        }

        function postMainCommentJS() {
            if (!checkLogin()) return;
            const input = document.getElementById('mainCommentContent');
            const content = input.value.trim();
            if (content === "") { alert("Comment cannot be empty!"); return; }

            fetch(contextPath + '/interaction/comment', {method: 'POST', body: new URLSearchParams({userId: currentUserId, cheatSheetId: currentSheetId, content: content})})
            .then(res => { if(!res.ok) throw new Error("Server error"); return res.json(); })
            .then(data => {
                const newId = data.id;
                const html = `
                <div id="commentThread_`+newId+`">
                    <div class="comment-box">
                        <div class="comment-author"><i class="fa-solid fa-circle-user text-primary me-1"></i> `+currentUserName+`</div>
                        <div class="comment-text">`+content+`</div>
                        <div class="mt-2">
                            <button type="button" id="cLikeBtn_`+newId+`" onclick="reactCommentJS(`+newId+`, true)" class="btn btn-sm btn-link text-decoration-none p-0 me-2 text-muted"><i class="bi bi-hand-thumbs-up-fill"></i> <span id="cLikeCount_`+newId+`">0</span></button>
                            <button type="button" id="cDislikeBtn_`+newId+`" onclick="reactCommentJS(`+newId+`, false)" class="btn btn-sm btn-link text-decoration-none p-0 me-3 text-muted"><i class="bi bi-hand-thumbs-down-fill"></i> <span id="cDislikeCount_`+newId+`">0</span></button>
                            <button type="button" class="btn btn-sm btn-link text-decoration-none p-0 text-muted" onclick="document.getElementById('replyForm_`+newId+`').style.display='block';"><i class="bi bi-reply"></i> Reply</button>
                        </div>
                    </div>
                    <div id="repliesContainer_`+newId+`"></div>
                    <div id="replyForm_`+newId+`" class="mt-3 p-3 rounded border" style="display:none; background: rgba(255, 255, 255, 0.45); backdrop-filter: blur(16px); border-color: rgba(255, 255, 255, 0.6) !important;">
                        <div class="input-group">
                            <input type="text" id="replyInput_`+newId+`" class="form-control" placeholder="Replying...">
                            <button class="btn btn-primary fw-bold" type="button" onclick="postReplyJS(`+newId+`)">Send</button>
                            <button class="btn btn-secondary" type="button" onclick="document.getElementById('replyForm_`+newId+`').style.display='none'">Cancel</button>
                        </div>
                    </div>
                </div>`;
                
                let msg = document.getElementById('noCommentsMsg');
                if (msg) msg.remove();
                
                document.getElementById('commentsWrapper').insertAdjacentHTML('beforeend', html);
                input.value = ''; 
            }).catch(err => alert("Action failed: " + err.message));
        }

        function postReplyJS(parentId) {
            if (!checkLogin()) return;
            const input = document.getElementById('replyInput_' + parentId);
            const content = input.value.trim();
            if (content === "") { alert("Reply cannot be empty!"); return; }

            fetch(contextPath + '/interaction/comment', {method: 'POST', body: new URLSearchParams({userId: currentUserId, cheatSheetId: currentSheetId, content: content, parentCommentId: parentId})})
            .then(res => { if(!res.ok) throw new Error("Server error"); return res.json(); })
            .then(data => {
                const newId = data.id;
                const html = `
                <div class="comment-box reply-box">
                    <div class="comment-author"><i class="fa-solid fa-reply text-info me-1"></i> `+currentUserName+`</div>
                    <div class="comment-text">`+content+`</div>
                    <div class="mt-2">
                        <button type="button" id="cLikeBtn_`+newId+`" onclick="reactCommentJS(`+newId+`, true)" class="btn btn-sm btn-link text-decoration-none p-0 me-2 text-muted"><i class="bi bi-hand-thumbs-up-fill"></i> <span id="cLikeCount_`+newId+`">0</span></button>
                        <button type="button" id="cDislikeBtn_`+newId+`" onclick="reactCommentJS(`+newId+`, false)" class="btn btn-sm btn-link text-decoration-none p-0 me-3 text-muted"><i class="bi bi-hand-thumbs-down-fill"></i> <span id="cDislikeCount_`+newId+`">0</span></button>
                        <button type="button" class="btn btn-sm btn-link text-decoration-none p-0 text-muted" onclick="document.getElementById('replyForm_`+parentId+`').style.display='block'; document.getElementById('replyInput_`+parentId+`').value='@`+currentUserName+` '"><i class="bi bi-reply"></i> Reply</button>
                    </div>
                </div>`;
                document.getElementById('repliesContainer_' + parentId).insertAdjacentHTML('beforeend', html);
                input.value = '';
                document.getElementById('replyForm_' + parentId).style.display = 'none'; 
            }).catch(err => alert("Action failed: " + err.message));
        }
    </script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const stars = document.querySelectorAll(".star-rating .star-icon");
            const ratingInput = document.getElementById("ratingSelect");
            if (stars.length > 0 && ratingInput) {
                let currentRating = parseInt(ratingInput.value);

                stars.forEach(star => {
                    star.addEventListener("mouseover", function() {
                        let value = this.getAttribute("data-value");
                        highlightStars(value);
                    });
                    star.addEventListener("mouseout", function() {
                        highlightStars(currentRating);
                    });
                    star.addEventListener("click", function() {
                        currentRating = this.getAttribute("data-value");
                        ratingInput.value = currentRating;
                        highlightStars(currentRating);
                        submitRatingJS(currentRating);
                    });
                });

                function highlightStars(value) {
                    stars.forEach(s => {
                        if (s.getAttribute("data-value") <= value) {
                            s.classList.remove("fa-regular", "text-muted");
                            s.classList.add("fa-solid", "text-warning");
                        } else {
                            s.classList.remove("fa-solid", "text-warning");
                            s.classList.add("fa-regular", "text-muted");
                        }
                    });
                }
                
                document.getElementById("rateSubmitBtn").addEventListener("click", function() {
                    currentRating = 0;
                    ratingInput.value = 0;
                    highlightStars(0);
                });
            }
        });
    </script>
</body>
</html>