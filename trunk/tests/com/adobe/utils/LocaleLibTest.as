/*
Adobe Systems Incorporated(r) Source Code License Agreement
Copyright(c) 2008 Adobe Systems Incorporated. All rights reserved.
	
Please read this Source Code License Agreement carefully before using
the source code.
	
Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive,
no-charge, royalty-free, irrevocable copyright license, to reproduce,
prepare derivative works of, publicly display, publicly perform, and
distribute this source code and such derivative works in source or
object code form without any attribution requirements.
	
The name "Adobe Systems Incorporated" must not be used to endorse or promote products
derived from the source code without prior written permission.
	
You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
against any loss, damage, claims or lawsuits, including attorney's
fees that arise or result from your use or distribution of the source
code.
	
THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT
ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. ALSO, THERE IS NO WARRANTY OF
NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT. IN NO EVENT SHALL MACROMEDIA
OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package com.adobe.utils
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	public class LocaleLibTest extends TestCase
	{
	    public function LocaleLibTest( methodName:String=null )
	    {
			super( methodName );
        }

		public function testParsing():void{
			var tests:Object = {
				'zh_CN': 'zh_Hans_CN',
				'zh_TW': 'zh_Hant_TW',
				'zh_Hans': 'zh_Hans_CN',
				'zh_Hant': 'zh_Hant_TW',
				'en_US': 'en_latn_US',
				'en': 'en_Latn_US',
				'ro': 'ro_Latn_RO',
				'ru': 'ru_Cyrl_RU',
				'it': 'it_Latn_IT',
				'zh_MO': 'zh_Hant_MO'
			};
			for(var locale:String in tests){
				assertEquals("LocaleId.fromString('"+locale+"').toString", tests[locale].toLowerCase(), LocaleId.fromString(locale).toString().toLowerCase());
			}			
		}

		private function createSorterTest(appLocales:String, systemPreferences:String, ultimateFallbackLocale:String, addAll:Boolean, expectedResult:String):Array{
			return [
				appLocales.split(','), systemPreferences.split(','), ultimateFallbackLocale, addAll, expectedResult
			];
		}
		
		public function testSorter():void{
			var tests:Array = [
				createSorterTest('zh_CN,ro,zh_TW','zh_Hant,ru,ja_JP,zh_Hans,ro,en', null, false, 'zh_TW,zh_CN,ro'),
				createSorterTest('zh_Hans,ro,zh_Hant','zh_TW,ru,ja_JP,zh_CN,ro,en', null, false, 'zh_Hant,zh_Hans,ro'),
				createSorterTest('ro_RO,ro','en,fr_FR,ro', null, false, 'ro,ro_RO'),
				createSorterTest('fr','en,fr_CA', null, false, 'fr'),
				createSorterTest('zh_CN,en_US,ro,ru,zh_TW','en,ro', null, true, 'en_US,ro,zh_CN,ru,zh_TW'),
				createSorterTest('ro_MD,zh_MO','en,ro,zh_Hans', null, false, 'ro_MD'),
				createSorterTest('ro_MD,zh_MO,zh_SG','en,ro,zh_Hant', null, false, 'ro_MD,zh_MO'),
			];
			for(var i:int=0; i<tests.length; i++){
				var testValues:Array = tests[i] as Array;
				var result:Array = LocaleUtil.sortLanguagesByPreference(testValues[0], testValues[1], testValues[2], testValues[3]);
				assertNotUndefined("LocaleUtil.sortLanguagesByPreference('"+testValues[0]+"','"+testValues[1]+"', '"+testValues[2]+"', '"+testValues[3]+"') returns 'undefined' at test "+ (i+1) + ".", result);
				assertNotNull("LocaleUtil.sortLanguagesByPreference('"+testValues[0]+"','"+testValues[1]+"', '"+testValues[2]+"', '"+testValues[3]+"') returns 'null' at test " + (i+1) + ".", result);
				assertEquals("LocaleUtil.sortLanguagesByPreference('"+testValues[0]+"','"+testValues[1]+"', '"+testValues[2]+"', '"+testValues[3]+"') at test " + (i+1) + ".", testValues[4], result.join(','));
			}
		}
	}
}