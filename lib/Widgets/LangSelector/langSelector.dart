import 'package:flutter/material.dart';
import 'package:meeter/View/Profile/const/gradient_const.dart';

class LangSelector extends StatefulWidget {
  String? ith;
  String? val;
  String? prof;

  String? _currentLanguage;
  String? _currentProf;

  String? get getcurrentLanguage => _currentLanguage;
  String? get getcurrentProf => _currentProf;

  LangSelector({this.ith, this.val, this.prof});

  @override
  _LangSelectorState createState() => _LangSelectorState();
}

class _LangSelectorState extends State<LangSelector> {
  List<String> _language = [
    'Abkhazian',
    'Afar',
    'Afrikaans',
    'Akan',
    'Albanian',
    'Amharic',
    'Arabic',
    'Aragonese',
    'Armenian',
    'Assamese',
    'Avaric',
    'Avestan',
    'Aymara',
    'Azerbaijani',
    'Bambara',
    'Bashkir',
    'Basque',
    'Belarusian',
    'Bengali',
    'Bihari languages',
    'Bislama',
    'Bosnian',
    'Breton',
    'Bulgarian',
    'Burmese',
    'Catalan, Valencian',
    'Central Khmer',
    'Chamorro',
    'Chechen',
    'Chichewa, Chewa, Nyanja',
    'Chinese',
    'Church Slavonic, Old Bulgarian, Old Church Slavonic',
    'Chuvash',
    'Cornish',
    'Corsican',
    'Cree',
    'Croatian',
    'Czech',
    'Danish',
    'Divehi, Dhivehi, Maldivian',
    'Dutch, Flemish',
    'Dzongkha',
    'English',
    'Esperanto',
    'Estonian',
    'Ewe',
    'Faroese',
    'Fijian',
    'Finnish',
    'French',
    'Fulah',
    'Gaelic, Scottish Gaelic',
    'Galician',
    'Ganda',
    'Georgian',
    'German',
    'Gikuyu, Kikuyu',
    'Greek (Modern)',
    'Greenlandic, Kalaallisut',
    'Guarani',
    'Gujarati',
    'Haitian, Haitian Creole',
    'Hausa',
    'Hebrew',
    'Herero',
    'Hindi',
    'Hiri Motu',
    'Hungarian',
    'Icelandic',
    'Ido',
    'Igbo',
    'Indonesian',
    'Interlingua (International Auxiliary Language Association)',
    'Interlingue',
    'Inuktitut',
    'Inupiaq',
    'Irish',
    'Italian',
    'Japanese',
    'Javanese',
    'Kannada',
    'Kanuri',
    'Kashmiri',
    'Kazakh',
    'Kinyarwanda',
    'Komi',
    'Kongo',
    'Korean',
    'Kwanyama, Kuanyama',
    'Kurdish',
    'Kyrgyz',
    'Lao',
    'Latin',
    'Latvian',
    'Letzeburgesch, Luxembourgish',
    'Limburgish, Limburgan, Limburger',
    'Lingala',
    'Lithuanian',
    'Luba-Katanga',
    'Macedonian',
    'Malagasy',
    'Malay',
    'Malayalam',
    'Maltese',
    'Manx',
    'Maori',
    'Marathi',
    'Marshallese',
    'Moldovan, Moldavian, Romanian',
    'Mongolian',
    'Nauru',
    'Navajo, Navaho',
    'Northern Ndebele',
    'Ndonga',
    'Nepali',
    'Northern Sami',
    'Norwegian',
    'Norwegian Bokmål',
    'Norwegian Nynorsk',
    'Nuosu, Sichuan Yi',
    'Occitan (post 1500)',
    'Ojibwa',
    'Oriya',
    'Oromo',
    'Ossetian, Ossetic',
    'Pali',
    'Panjabi, Punjabi',
    'Pashto, Pushto',
    'Persian',
    'Polish',
    'Portuguese',
    'Quechua',
    'Romansh',
    'Rundi',
    'Russian',
    'Samoan',
    'Sango',
    'Sanskrit',
    'Sardinian',
    'Serbian',
    'Shona',
    'Sindhi',
    'Sinhala, Sinhalese',
    'Slovak',
    'Slovenian',
    'Somali',
    'Sotho, Southern',
    'South Ndebele',
    'Spanish, Castilian',
    'Sundanese',
    'Swahili',
    'Swati',
    'Swedish',
    'Tagalog',
    'Tahitian',
    'Tajik',
    'Tamil',
    'Tatar',
    'Telugu',
    'Thai',
    'Tibetan',
    'Tigrinya',
    'Tonga (Tonga Islands)',
    'Tsonga',
    'Tswana',
    'Turkish',
    'Turkmen',
    'Twi',
    'Uighur, Uyghur',
    'Ukrainian',
    'Urdu',
    'Uzbek',
    'Venda',
    'Vietnamese',
    'Volap_k',
    'Walloon',
    'Welsh',
    'Western Frisian',
    'Wolof',
    'Xhosa',
    'Yiddish',
    'Yoruba',
    'Zhuang, Chuang',
    'Zulu'
  ];

  List<String> prof = ["Elementary", "Fluent", "Native"];

  Widget langSelect() {
    final w = MediaQuery.of(context).size.width / 100;
    final h = MediaQuery.of(context).size.height / 100;

    void changeDropDownLocationItemLang(String? selectedLang) {
      setState(() {
        widget._currentLanguage = selectedLang;
      });
    }

    void changeDropDownLocationItemProf(String? selectedProf) {
      setState(() {
        widget._currentProf = selectedProf;
      });
    }

    return Column(
      children: [
        Wrap(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                  w * 2.0370, h * 0.9954, w * 2.0370, h * 0.9954),
              child: locationColorBox(
                  context,
                  SIGNUP_BACKGROUND,
                  "${widget.ith} Language",
                  widget._currentLanguage,
                  _language,
                  changeDropDownLocationItemLang),
            ),
            Wrap(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      w * 2.0370, h * 0.9954, w * 2.0370, h * 0.9954),
                  child: locationColorBox(
                      context,
                      SIGNUP_BACKGROUND,
                      "Language proficiency ",
                      widget._currentProf,
                      prof,
                      changeDropDownLocationItemProf),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  Widget locationColorBox(BuildContext context, Gradient gradient, String title,
      String? currentLocation, List<String> array, Function(String?)? change) {
    final w = MediaQuery.of(context).size.width / 100;
    final h = MediaQuery.of(context).size.height / 100;

    return Padding(
      padding: EdgeInsets.only(
        left: w * 7.63888,
        right: w * 7.63888,
        bottom: h * 0.99547,
      ),
      child: Container(
        height: h * 7.4660,
        decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(w * 2.546),
            border: Border.all(
              color: Color(0xff00AEFF),
            )),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: w * 7.6388,
            ),
            Expanded(
              flex: 3,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.w400,
                ),
                textScaleFactor: 1,
              ),
            ),
            Expanded(
              flex: 2,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                    isDense: false,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    isExpanded: true,
                    onChanged: change,
                    items: array.map((item) {
                      return DropdownMenuItem<String>(
                        onTap: () {},
                        value: item,
                        child: Text(
                          item,
                          textScaleFactor: 1,
                        ),
                      );
                    }).toList(),
                    value: currentLocation),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget._currentLanguage = widget.val;
    widget._currentProf = widget.prof;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return langSelect();
  }
}
