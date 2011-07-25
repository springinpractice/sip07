function blockMessage() {
	$.ajax({
		url: messageUrl + '/visible',
		type: 'POST',
		data: { _method: 'PUT', value: false },
		success: function(data, textStatus, xhr) {
			if (xhr.status == 200) {
				$('#blockLink').hide();
				$('#unblockLink').show();
				$('#blockedAlert').slideDown();
			} else {
				this.error();
			}
		},
		error: function() {
			$('<div title="Error">An error occurred while trying to block the message.</div>').dialog({
				modal: true,
				buttons: { Ok: function() { $(this).dialog('close'); } }
			});
		}
	});
}

function unblockMessage() {
	$.ajax({
		url: messageUrl + '/visible',
		type: 'POST',
		data: { _method: 'PUT', value: true },
		success: function(data, textStatus, xhr) {
			if (xhr.status == 200) {
				$('#unblockLink').hide();
				$('#blockLink').show();
				$('#blockedAlert').slideUp();
			} else {
				this.error();
			}
		},
		error: function() {
			$('<div title="Error">An error occurred while trying to unblock the message.</div>').dialog({
				modal: true,
				buttons: { Ok: function() { $(this).dialog('close'); } }
			});
		}
	});
}

function confirmDeleteMessage() {
	$('<div title="Confirm deletion">This will permanently delete this message. Are you sure?</div>').dialog({
		modal: true,
		width: 480,
		buttons: {
			'Delete message': function() {
				actuallyDeleteMessage();
				$(this).dialog('close');
			},
			Cancel: function() { $(this).dialog('close'); }
		}
	});
}

function actuallyDeleteMessage() {
	$('#deleteForm').submit();
}

function kickIt(visible) {
	$('#blockLink a').click(function() { blockMessage(); return false; });
	$('#unblockLink a').click(function() { unblockMessage(); return false; });
	$('#deleteLink a').click(function() { confirmDeleteMessage(); return false; });
	
	if (visible) {
		$("#blockedAlert").hide();
		$("#unblockLink").hide();
	} else {
		$("#blockLink").hide();
	}
}
