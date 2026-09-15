DST_STR = 1
DST_DEX = 2
DST_INT = 3
DST_STA = 4 

-- II_WEA_SWO_LONG(23번) 장착 함수
function F23_equip( pMover )
	Trace( "LONG 소드 장착" )
	
	SetDestParam( pMover, DST_STR, 3 );
	return 1
end

-- II_WEA_SWO_LONG(23번) 탈착 함수
function F23_unequip( pMover )
	Trace( "LONG 소드 탈착" )
	ResetDestParam( pMover, DST_STR, 3 );
	return 1
end

 
