function setMessageVisible(id, visible) {
	$.ajax({
		url: messageUrl + '/visible',
		type: 'POST',
		data: { _method: 'PUT', value: visible },
		success: function(data, textStatus, xhr) {
			if (xhr.status == 200) {
				refreshUi(visible);
			} else {
				this.error();
			}
		},
		error: function() {
			var action = (visible ? 'unblock' : 'block')
			$('<div title="Error">An error occurred while trying to ' + action + ' the message.</div>').dialog({
				modal: true,
				buttons: { Ok: function() { $(this).dialog('close'); } }
			});
		}
	});
}

function refreshUi(visible) {
	if (visible) {
		$('#blockLink').show();
		$('#unblockLink').hide();
		$('#blockedAlert').slideUp();
	} else {
		$('#blockLink').hide();
		$('#unblockLink').show();
		$('#blockedAlertContainer').empty().append(blockedAlert);
		$('#blockedAlert').hide().slideDown();
	}
}

function confirmDeleteMessage(id) {
	$('<div title="Confirm deletion">This will permanently delete this message. Are you sure?</div>').dialog({
		modal: true,
		width: 480,
		buttons: {
			'Delete message': function() {
				actuallyDeleteMessage(id);
				$(this).dialog('close');
			},
			Cancel: function() { $(this).dialog('close'); }
		}
	});
}

function actuallyDeleteMessage(id) {
	$('#deleteForm').submit();
}

function kickIt(id, visible) {
	$('#blockUnblockContainer').empty().append(blockLink).append(unblockLink);
	$('#blockLink a').click(function() { setMessageVisible(id, false); return false; });
	$('#unblockLink a').click(function() { setMessageVisible(id, true); return false; });
	$('#deleteLink a').click(function() { confirmDeleteMessage(id); return false; });
	refreshUi(visible);
}
