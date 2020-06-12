import consumer from "./consumer"

consumer.subscriptions.create("TicketsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    const commentsTag = document.querySelector(".tickets #comments");
    const div = document.createElement("div");
    div.innerHTML = data.comments;
    commentsTag.insertBefore(div, commentsTag.firstChild);

    const comment = document.getElementById('comment_content');
    comment.value = '';
  }
});
