package com.example.common;

public class IdGenerator {
	
	public static int NewId() {
		return ++m_nId;
	}
	private static int m_nId = 1;
}
