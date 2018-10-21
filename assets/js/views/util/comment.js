export default (channel) => {
  let msgBox = document.getElementById('user-comment');

  document.getElementById('send-comment').onclick = (_) =>{
    sendComment();
  };

  msgBox.addEventListener('keydown', (e) => {
    if(e.which == 13) {
      sendComment();
    };
  });

  channel.on("stream:comment_sent", (resp) => {
    let log = document.getElementById('chat-log');
    let commentPanel = document.createElement("div");
    commentPanel.className = "panel-block";
    commentPanel.innerHTML = resp.user_name + "：" + resp.comment.content;
    msgBox.value = "";
    log.prepend(commentPanel);
  });

  const sendComment = () => {
    if(msgBox.value) {
      channel.push("stream:send_comment", {comment: msgBox.value});
    };
  };
};
