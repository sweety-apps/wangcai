package com.example.wangcai;

public class IdGenerator {
	public int NewId() {
		return ++m_nId;
	}
	private int m_nId = 1;
}
