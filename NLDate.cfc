/*
* Author	:	Don Quist (don@sigmaprojects.org - http://www.sigmaprojects.org)
* GitHub	:	https://github.com/sigmaprojects/CF-NLDate/
*/
	
component hint="Natural Language Date Parser" {

	public NLDate function init() {
		variables.words = 'one,two,three,four,five,six,seven,eight,nine,ten,eleven,twelve,thirteen,fourteen,fifteen,sixteen,seventeen,eighteen,ninteen,twenty,twentyone,twentytwo,twentythree,twentyfour,twentyfive,twentysix,twentyseven,twentyeight,twentynine,thirty,thirtyone,thirtytwo,couple,few,a,an';
		variables.numbers = '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,2,3,1,1';
		variables.months = 'Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec';
		return this;
	}

	public string function Parse(Required String When,Date Date) {
		var str = trim(lcase(arguments.When));
		if(structKeyExists(arguments,'Date')) {
			var d = arguments.date;
		} else {
			var d = Now();
		}
		switch(left(str,3)) {
			case 'yes': { // yesterday
				return DateAdd('d',-1,d);
				break;
			}
			case 'tod': { // today
				return d;
				break;
			}
			case 'tom': { // tomorrow
				return DateAdd('d',1,d);
				break;
			}
			case 'sun': case 'mon': case 'tue': case 'wed': case 'thu': case 'fri': case 'sat': {
				return PrevOccOfDOW(part,d);
				break;
			}
		}
		if( left(str,4) is 'last') {
			var part = ListLast(str,' ');
			if(part is 'month') {part='mmm';} // *(see below)
			if(IsMonth(part)) {
				var n = ListFindNoCase(variables.months, Left(part,3));
				return DateAdd('m',-(DatePart('m',d)-n),d);
			}
			switch(left(part,3)) {
				case 'sun': case 'mon': case 'tue': case 'wed': case 'thu': case 'fri': case 'sat': {
					return PrevOccOfDOW(part,d);
					break;
				}
				case 'mmm': { // *lil hacky
					return DateAdd('m',-1,d);
					break;
				}
				case 'wee': {
					return DateAdd('ww',-1,d);
						break;
				}
				case 'yea': {
					return DateAdd('y',-1,d);
					break;
				}
			}
		}
		
		if( left(str,2) is 'in' && ListLen(str,' ') gte 2 ) {
			
			var tn = listGetAt(str,2,' ');

			if( !isNumeric(tn) ) {
				var tnn = TextToNumber(tn);
				if( tnn ) {
					var i = tnn;
				}
			} else {
				var i = tn;
			}

			if( IsNumeric(i) ) {
				var part = listLast(str,' ');
				var offset = i;
				var ipart = Left(part,1);
				if(Right(part,1) is 's') { part = left(part,len(part)-1); };
				switch(part) {
					case 'second': case 'sec': { ipart = 's'; break; }
					case 'minute': case 'min': { ipart = 'n'; break; }
					case 'hour': { ipart = 'h'; break; }
					case 'day': { ipart = 'd'; break; }
					case 'week': { ipart = 'ww'; break; }
					case 'month': { ipart = 'm'; break; }
					case 'quarter': { ipart = 'q'; break; }
					case 'year': { ipart = 'yyyy'; break; }
					default: { ipart = 'h'; break; }
				}
				return DateAdd(ipart,offset,d);
			}
		} else if( ListLen(str,' ') gte 2 ) {
			if(Left(str,2) is 'a ') {
				str = right(str,len(str)-2);
			}
			var i = listFirst(str,' ');
			var tnn = TextToNumber(i);
			if( tnn ) {
				i = tnn;
			}
			if( IsNumeric(i) ) {
				var offset = i;
				var part = listGetAt(str,2,' ');
				var ipart = Left(part,1);
				if(Right(part,1) is 's') { part = left(part,len(part)-1); };
				switch(part) { // didn't have to be a swich, could have just done left(part,1), see why below.
					case 'day': { ipart = 'd'; break; }
					case 'week': { ipart = 'ww'; break; } // your annoying, w should be WEEK, not just weekday.
					case 'month': { ipart = 'm'; break; }
					case 'quarter': { ipart = 'q'; break; }
					case 'year': { ipart = 'yyyy'; break; } // you too, making things difficult.
					default: { ipart = 'd'; break; }
				}
				return DateAdd(ipart,-offset,d);
			}
		}
		return d;
	}


	public numeric function TextToNumber(Required String sStr) {
		// uh, not exactly scaleable - but for this purpose it'll do just fine
		var str = trim(lcase(arguments.sStr));
		var i = 0;
		var num = 0;
		if( listContains(variables.words,str) ) {
			i = listFindNoCase(variables.words,str);
			num = listGetAt(variables.numbers,i);
		}
		return num;
	}

	public string function PrevOccOfDOW(Required String DayOf,Date D) {
		// original http://www.cflib.org/udf/PrevOccOfDOW
		if(!StructKeyExists(arguments,'D')) {
			var Date = Now();
		} else {
			var Date = D;
		}
		var day = Trim(Lcase(arguments.DayOf));
		if(!IsNumeric(day)) {
			switch(lCase(left(day,3))) {
				case 'sun': { day = 1; break; }
				case 'mon': { day = 2; break; }
				case 'tue': { day = 3; break; }
				case 'wed': { day = 4; break; }
				case 'thu': { day = 5; break; }
				case 'fri': { day = 6; break; }
				case 'sat': { day = 7; break; }
				default: { day = 1; break; }
			}
		}
		var dayOffset = 7;
		if(Day LT DayOfWeek(Date)) {
			dayOffset = 0;
		}
		return DateAdd("d",- (dayOffset - (day - DayOfWeek(Date))),Now());
	}

	public boolean function IsMonth(Required String Month) {
		var str = trim(arguments.Month);
		if(len(str) lt 3) {return false;};
		return ListContainsNoCase(variables.months,left(str,3));
	}	
}