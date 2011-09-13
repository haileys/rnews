$(function() {
	
	$(".link_voting form").live("ajax:success", function(ev, html) {
		$(this).parents(".linkbox").replaceWith(html);
	});
	
	$(".comment_voting form").live("ajax:success", function(ev, html) {
		var comment = $(this).parents(".comment");
		var id = comment.attr("id");
		var children = comment.children(".children").detach();
		$(comment).replaceWith(html);
		$("#" + id).append(children);
	})
});