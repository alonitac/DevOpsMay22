var botui = new BotUI('my-botui-app');


function enterText() {
    botui.action.text({
        action: {
            placeholder: 'Enter your text'
        }
    }).then(function (res) {

        console.log(res);

        $.ajax({
            contentType: 'application/json',
            data: JSON.stringify({text: res.value}),
            dataType: 'json',
            success: function(data){
                for (let i = 0; i < data.items.length; i++) {
                    botui.message.add({
                        content: data.items[i].text
                    });

                    if (data.items[i].videoId) {
                        botui.message.add({
                            type: 'embed',
                            content: 'https://www.youtube.com/embed/' + data.items[i].videoId
                        });
                    }
                }

                enterText();
            },
            type: 'POST',
            url: '/youtube'
        });
    });

}

enterText();
