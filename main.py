from flask import Flask, request, abort
from linebot import (
    LineBotApi, WebhookHandler
)
from linebot.exceptions import (
    InvalidSignatureError
)
from linebot.models import (
    MessageEvent, TextMessage, TextSendMessage, ImageSendMessage
)
import os
app = Flask(__name__)

YOUR_CHANNEL_ACCESS_TOKEN = os.environ["YOUR_CHANNEL_ACCESS_TOKEN"]
YOUR_CHANNEL_SECRET = os.environ["YOUR_CHANNEL_SECRET"]
line_bot_api = LineBotApi(YOUR_CHANNEL_ACCESS_TOKEN)
handler = WebhookHandler(YOUR_CHANNEL_SECRET)
# def createMessages():
#     messages = ["https://cdn.glitch.me/2d52d322-2687-4a32-9222-20396f002ffc%2F1181.png?v=1637432022254", "QRコードをタブレットにかざしてください。"]
#     send_messages = [
#         ImageSendMessage(original_content_url='https://cdn.glitch.me/2d52d322-2687-4a32-9222-20396f002ffc%2F8131.png?1637433607474',preview_image_url='https://cdn.glitch.me/2d52d322-2687-4a32-9222-20396f002ffc%2F8131.png?1637433607474')),
#         TextSendMessage(text="QRコードをタブレットにかざしてください。")
#     ]
#     # send_messages.append(ImageSendMessage(originalContentUrl=messages[0],previewImageUrl=messages[0]))
#     # send_messages.append(TextSendMessage(text=messages[1]))
#     return send_messages
@app.route("/callback", methods=['POST'])
def callback():
    # get X-Line-Signature header value
    signature = request.headers['X-Line-Signature']
    # get request body as text
    body = request.get_data(as_text=True)
    app.logger.info("Request body: " + body)
    # handle webhook body
    try:
        handler.handle(body, signature)
    except InvalidSignatureError:
        abort(400)
    return 'OK'
@handler.add(MessageEvent, message=TextMessage)
def handle_message(event):
    if event.message.text == "電話":
        line_bot_api.reply_message(
            event.reply_token,
            TextSendMessage(text="総合フロント(Reception)\n福岡市中央区天神3丁目3-20\n3-3-20, Tenjin, Chuo-ku, Fukuoka-shi\nTEL:050-1748-1277"))
    elif "予約" in event.message.text:
        line_bot_api.reply_message(
            event.reply_token,
            TextSendMessage(text="ORIGO HAKATA -Gion-\n予約サイト\nURL:https://www.chillnn.com/17ae0a03b393a7/plan/17ae5fcc7313b9"))
    elif "チェックイン" in event.message.text:
        line_bot_api.reply_message(
            event.reply_token,
            TextSendMessage(text="チェックインは16時~22時にお願いします。\nご予約の部屋番号を教えてください"))
    # elif "603" in event.message.text:
    #     line_bot_api.reply_message(
    #         event.reply_token,
    #         # createMessages()
    #     )
    elif "602" in event.message.text:
        line_bot_api.reply_message(
            event.reply_token,
            ImageSendMessage(original_content_url='https://cdn.glitch.me/2d52d322-2687-4a32-9222-20396f002ffc%2F8131.png?1637433607474',preview_image_url='https://cdn.glitch.me/2d52d322-2687-4a32-9222-20396f002ffc%2F8131.png?1637433607474'))
    elif "601" in event.message.text:
        line_bot_api.reply_message(
            event.reply_token,
            ImageSendMessage(original_content_url='https://cdn.glitch.me/2d52d322-2687-4a32-9222-20396f002ffc%2F8931.png?1637433671713',preview_image_url='https://cdn.glitch.me/2d52d322-2687-4a32-9222-20396f002ffc%2F8931.png?1637433671713'))
    elif "遅れ" in event.message.text:
        line_bot_api.reply_message(
            event.reply_token,
            TextSendMessage(text="本ホテルは無人です、16時以降いつでも入場可能です"))
    elif "変更" in event.message.text:
        line_bot_api.reply_message(
            event.reply_token,
            TextSendMessage(text="予約を変更しました。\n以下のQRコードをタブレットにかざしてください。"))
    elif "キャンセル" in event.message.text:
        line_bot_api.reply_message(
            event.reply_token,
            TextSendMessage(text="予約をキャンセルしました。\nまたのご来店を心よりお待ちしております。"))
    elif "風呂" in event.message.text:
        line_bot_api.reply_message(
            event.reply_token,
            TextSendMessage(text="シャンプー、リンス、ボディソープを完備！アメニティ充実！！\n\( *´ω`* )/"))
    elif "住所" in event.message.text:
        line_bot_api.reply_message(
            event.reply_token,
            TextSendMessage(text="HOTEL ORIGO HAKATA -Gion-\n〒812-0038\n福岡県福岡市博多区祇園町2-31\nフィルパーク博多祇園\nURL:https://goo.gl/maps/DuGPSGgBSP8oNP9Y9 \nご利用を心よりお待ちしておりますヽ(*ﾟ▽ﾟ)ﾉ"))
    elif "サイト" in event.message.text:
        line_bot_api.reply_message(
            event.reply_token,
            TextSendMessage(text="公式のホームページはこちら\nURL:https://origo-hotels.com/origohakatagion"))
    elif "パスワード" in event.message.text:
        line_bot_api.reply_message(
            event.reply_token,
            TextSendMessage(text="1181⋆"))
    elif "場所" in event.message.text:
        line_bot_api.reply_message(
            event.reply_token,
            TextSendMessage(text="場所が分からない方へ(゜▽゜)!\n祇園からホテルまでのストリートビューはこちら\n祇園からホテルまで徒歩で約2分、200mほどの距離です。\nURL:https://youtu.be/ah0cip9i-5A"))
    else:
        line_bot_api.reply_message(
            event.reply_token,
            TextSendMessage(text=event.message.text))
if __name__ == "__main__":
#    app.run()
    port = int(os.getenv("PORT", 5000))
    app.run(host="0.0.0.0", port=port)