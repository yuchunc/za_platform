export default (channel) => {
  document.getElementById('send-comment').onclick = (_) =>{
    const message = document.getElementById('user-comment').value;

    if(message) {
      channel.push("stream:send_comment", {comment: message});
    }
  };

  channel.on("stream:comment_sent", (resp) => {
    let log = document.getElementById('chat-log');
    let commentPanel = document.createElement("div");
    commentPanel.className = "panel-block";
    commentPanel.innerHTML = resp.user_name + "：" + resp.comment.content;
    log.prepend(commentPanel);
  });
};
