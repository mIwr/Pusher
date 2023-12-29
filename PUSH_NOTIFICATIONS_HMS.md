# Пуш-уведомления HMS

## HMS PushKit API

[Push aspects](https://developer.huawei.com/consumer/en/doc/development/HMSCore-References/https-send-api-0000001050986197)

### HMS HTTP v1 API

[Info](https://developer.huawei.com/consumer/en/doc/development/HMSCore-References/https-send-api-0000001050986197)

Данный тип API покрывает задачи отправки пушей в конкретное приложение в проекте Huawei App Gallery. 
То есть если отправить пуш по токену другого приложения (считается и кейс, если приложение одно и то же, но разная платформа) в этом же проекте, то вернется ошибка.

URL: https://push-api.cloud.huawei.com/v1/{AppID}/messages:send
Required headers:
- Authorization: Bearer {OAuth token};
- Content-Type: application/json; charset=UTF-8.

OAuth токен генерируется из appID, clID и client secret определенного приложения в проекте через [POST https://oauth-login.cloud.huawei.com/oauth2/v3/token](https://developer.huawei.com/consumer/en/doc/development/HMSCore-Guides/oauth2-0000001212610981#section128682386159)

Так как Firebase поддерживает отправку и на Android, и на iOS, плюс является более популярным решением, то HMS Push Kit можно использовать для покрытия пушами только Android-устройств (Huawei, суббренды и прочие устройства с HMS сервисами)

Пример JSON пуш-сообщения, которое будет корректно обработано Android (Data-only):

```dart
{
  "message": {
    "token":["token1","token2"], 
    "data": "{'content':'{'channelKey':'channel','title':'Title','body':'Body'}'}"
  }
}
```

**Особенности**
+ Возможность кастомизации пуш-уведомления для каждой платформы по отдельности
+ Поддержка *data* из коробки
+ Поддержка всех параметров пуша для APNS
- Сложность развертывания: необходимо генерировать токен для отправки пуша
- Ограниченность в сценариях использования: Huawei Push Kit преподносится как кроссплатформенное решение для пушей (Android, iOS и др.), однако использование в кроссплатформенных проектах с API данной версии сильно усложнено ввиду необходимости реализации на стороне back-end'а механизма менеджмента токенов для каждого конкретного приложения и платформы 

### HMS HTTP v2 API

[Info](https://developer.huawei.com/consumer/en/doc/development/HMSCore-References/https-send-api-0000001050986197)

Следующая итерация, решающая главный минус прошлой ревизии API и приближенная по функциональности и удобности к Firebase.
Данный тип API позволяет отправлять пуши на уровне проекта Huawei App Gallery. Менеджмент по приложениям и платформам реализован на стороне Huawei

URL: https://push-api.cloud.huawei.com/v2/{ProjectID}/messages:send
Required headers:
- Authorization: Bearer {OAuth token};
- Content-Type: application/json; charset=UTF-8.

OAuth токен генерируется аналогично v1 API из appID, clID и client secret любого приложения из проекта через [POST https://oauth-login.cloud.huawei.com/oauth2/v3/token](https://developer.huawei.com/consumer/en/doc/development/HMSCore-Guides/oauth2-0000001212610981#section128682386159)

Пример JSON пуш-сообщения, которое будет корректно обработано Android (Data-only):

```dart
{
  "message": {
    "token":["token1","token2"],
    "data": "{'content':'{'channelKey':'channel','title':'Title','body':'Body'}'}"
  }
}
```

**Особенности**
+ Плюсы ревизии v1 API
+ Упрощение реализации на стороне back-end: достаточно отправлять пуш-токен по url'у проекта, и если токен действующий, то Huawei сам определит нужное приложение и платформу и отправит пуш
- Сложность и неоднозначность при развертывании: необходимо генерировать токен для отправки пуша + для генерации токена необходимо указывать все также доступы от конкретного приложения, хотя OAuth токен на выходе имеет уровень проекта