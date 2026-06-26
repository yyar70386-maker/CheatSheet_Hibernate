<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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
        body { background-color: #ffffff; }
        .detail-container { max-width: 900px; margin: 60px auto; padding: 0 20px; }
        .sheet-title { font-size: 48px; font-weight: 800; color: #222222; display: inline-block; }
        .author-text { font-size: 22px; color: #777777; font-weight: bold; margin-left: 10px; }
        .description-text { font-size: 18px; color: #444444; margin-top: 25px; margin-bottom: 35px; line-height: 1.6; }
        
        .code-container-box { background-color: #f8f5f2; border-radius: 14px; padding: 25px 30px; margin-bottom: 35px; }
        .plain-code-text { font-family: 'Courier New', Courier, monospace; font-size: 18px; line-height: 1.5; color: #333333; margin: 0; white-space: pre-wrap; word-break: break-all; }
        
        .tag-badge { background-color: #e2e8f0; color: #333; padding: 8px 18px; border-radius: 20px; font-size: 14px; font-weight: bold; text-decoration: none; display: inline-block; }
        .tag-badge:hover { background-color: #1976d2; color: white; }

        .interaction-bar { background: #fdfdfd; padding: 15px 20px; border-radius: 10px; border: 1px solid #eee; margin-top: 30px; display: flex; align-items: center; gap: 15px; flex-wrap: wrap; }
        .action-btn { background: none; border: 1px solid #ddd; padding: 8px 15px; border-radius: 20px; font-weight: 600; color: #555; transition: 0.2s; }
        .action-btn:hover { background: #f0f0f0; }
        
        .btn-heart:hover, .btn-heart.active { background: #fff0f1; color: #e63946; border-color: #e63946; }
        .btn-like:hover, .btn-like.active { background: #e0fbfc; color: #028090; border-color: #028090; }
        .btn-dislike:hover, .btn-dislike.active { background: #fae0e4; color: #d62828; border-color: #d62828; }

        .comment-section { margin-top: 50px; }
        .comment-box { background: #fafafa; padding: 15px; border-radius: 10px; margin-bottom: 15px; border: 1px solid #eee; }
        .reply-box { margin-left: 50px; border-left: 3px solid #0dcaf0; background: #fcfcfc; }
        .comment-author { font-weight: bold; color: #333; font-size: 15px; }
        .comment-text { margin-top: 8px; color: #555; font-size: 15px; line-height: 1.5; }
    </style>
</head>
<body>

    <jsp:include page="header.jsp" />

    <div class="container mt-4">
        <a href="${pageContext.request.contextPath}/cheatsheet/list" class="btn btn-outline-secondary mb-3"><i class="bi bi-arrow-left"></i> Back to List</a>
    </div>

    <div class="detail-container">
        
        <%-- 🌟 Title & Author (Profile Link + View Count အပြည့်အစုံ ပေါင်းစပ်ပြီး) --%>
        <div>
            <h1 class="sheet-title">${sheet.title}</h1>
            <span class="author-text">by 
                <c:choose>
                    <c:when test="${sheet.author != null}">
                        <a href="${pageContext.request.contextPath}/profile/${sheet.author.id}" 
                           class="text-dark fw-bold text-decoration-none" 
                           style="border-bottom: 2px solid #0d6efd; padding-bottom: 2px;">
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
 
        <%-- 🌟 Description Section --%>
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

        <%-- 🌟 INTERACTION BAR (AJAX Seamless) --%>
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
                        <select id="ratingSelect" class="form-select form-select-sm me-2" style="width: 100px; cursor:pointer;">
                            <option value="5" ${userRating == 5 ? 'selected' : ''}>5 Stars</option>
                            <option value="4" ${userRating == 4 ? 'selected' : ''}>4 Stars</option>
                            <option value="3" ${userRating == 3 ? 'selected' : ''}>3 Stars</option>
                            <option value="2" ${userRating == 2 ? 'selected' : ''}>2 Stars</option>
                            <option value="1" ${userRating == 1 ? 'selected' : ''}>1 Star</option>
                        </select>
                        <button type="button" id="rateSubmitBtn" onclick="submitRatingJS()" class="btn btn-sm btn-outline-warning text-dark fw-bold">Rate / Undo</button>
                    </div>
                </c:when>

                <c:otherwise>
                    <span class="text-muted"><i class="bi bi-info-circle text-primary"></i> Please <strong><a href="${pageContext.request.contextPath}/login" class="text-decoration-none">Login</a></strong> to interact.</span>
                    <span class="ms-auto fw-bold text-dark"><i class="fa-solid fa-star text-warning"></i> ${avgRating > 0 ? avgRating : '0.0'}</span>
                </c:otherwise>
            </c:choose>
        </div>

        <%-- 🌟 COMMENTS SECTION --%>
        <div class="comment-section">
            <h3 class="mb-4"><i class="bi bi-chat-dots-fill text-primary"></i> Comments</h3>

            <c:choose>
                <c:when test="${not empty sessionScope.currentUser}">
                    <div class="mb-5 p-4 bg-light rounded border">
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
                                <div id="replyForm_${comment.id}" class="mt-3 p-3 bg-light rounded border" style="display:none;">
                                    <div class="input-group">
                                        <input type="text" id="replyInput_${comment.id}" class="form-control" placeholder="Replying...">
                                        <button class="btn btn-info text-white fw-bold" type="button" onclick="postReplyJS(${comment.id})">Send</button>
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

    <%-- 🌟 JAVASCRIPT FOR SEAMLESS UI (NO REFRESH) --%>
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

        function submitRatingJS() {
            if (!checkLogin()) return;
            let stars = document.getElementById('ratingSelect').value;
            fetch(contextPath + '/rating/submit', {method: 'POST', body: new URLSearchParams({userId: currentUserId, cheatSheetId: currentSheetId, stars: stars})})
            .then(() => {
                let btn = document.getElementById('rateSubmitBtn');
                let originalText = btn.innerText;
                btn.innerText = "Saved!"; btn.classList.replace('btn-outline-warning', 'btn-success');
                setTimeout(() => { btn.innerText = originalText; btn.classList.replace('btn-success', 'btn-outline-warning'); }, 2000);
            }).catch(err => alert("Error: " + err.message));
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
                    <div id="replyForm_`+newId+`" class="mt-3 p-3 bg-light rounded border" style="display:none;">
                        <div class="input-group">
                            <input type="text" id="replyInput_`+newId+`" class="form-control" placeholder="Replying...">
                            <button class="btn btn-info text-white fw-bold" type="button" onclick="postReplyJS(`+newId+`)">Send</button>
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
</body>
</html>