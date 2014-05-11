package com.example.request;

public class RequesterFactory {

	public static enum RequestType {
		RequestType_Login,					//��½
		RequestType_Lottery,				//�齱
		RequestType_BindPhone,			//���ֻ�
		RequestType_ResendCaptcha,	//�ط���֤��
		RequestType_VerifyCaptcha,		//�����֤��
		RequestType_UpdateUserInfo,	//�����û���Ϣ(�ʾ����)
		RequestType_GetUserInfo,			//��ȡ�û���Ϣ(�ʾ����)
		RequestType_ExtractPhoneBill,	//���ѳ�ֵ
		RequestType_ExtractQBi,			//Q�ҳ�ֵ
		RequestType_ExtractAliPay,		//֧������ֵ
		RequestType_UpdateInviter,		//����������
	}
	

	public static Requester NewRequest(RequestType enumRequestType) {
		Requester req = null;
		switch (enumRequestType){
		case RequestType_Login:
			req = new Request_Login();
			break;
		case RequestType_Lottery:
			req = new Request_Lottery();
			break;
		case RequestType_BindPhone:
			req = new Request_BindPhone();
			break;
		case RequestType_ResendCaptcha:
			req = new Request_ResendCaptcha();
			break;
		case RequestType_UpdateUserInfo:
			req = new Request_UpdateUserInfo();
			break;
		case RequestType_GetUserInfo:
			req = new Request_GetUserInfo();
			break;
		case RequestType_ExtractPhoneBill:
			req = new Request_ExtractPhoneBill();
			break;
		case RequestType_ExtractQBi:
			req = new Request_ExtractQBi();
			break;
		case RequestType_ExtractAliPay:
			req = new Request_ExtractAliPay();
			break;
		case RequestType_VerifyCaptcha:
			req = new Request_VerifyCaptcha();
			break;
		case RequestType_UpdateInviter:
			req = new Request_UpdateInviter();
			break;
		default:
			return req;
		}
		req.SetRequestType(enumRequestType);
		return req;
	}
	
	
}
