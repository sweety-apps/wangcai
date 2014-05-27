package com.example.request;

import com.example.request.Requesters.*;

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
		RequestType_GetExchangeList,	//
		RequestType_GetExchangeCode,	//
		RequestType_Poll,					//
		RequetsType_DownloadApp,		//
		RequestType_Share,					//
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
		case RequestType_GetExchangeList:
			req = new Request_GetExchangeList();
			break;
		case RequestType_GetExchangeCode:
			req = new Request_GetExchangeCode();
			break;
		case RequestType_Poll:
			req = new Request_Poll();
			break;
		case RequetsType_DownloadApp:
			req = new Request_DownloadApp();
		case RequestType_Share:
			req = new Request_Share();
			break;
		default:
			return req;
		}
		req.SetRequestType(enumRequestType);
		return req;
	}
	
	
}
