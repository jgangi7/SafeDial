//
//  LocalizedStrings.swift
//  SafeDial
//
//  Created by Jimmy Gangi on 3/5/26.
//

import Foundation
import SwiftUI

/// Keys for all localizable strings in the app
enum LocalizedStringKey: String, CaseIterable {
    // MARK: - General
    case cancel = "cancel"
    case done = "done"
    case change = "change"
    case search = "search"
    case settings = "settings"
    
    // MARK: - Location & Country
    case location = "location"
    case selectCountry = "select_country"
    case searchCountry = "search_country"
    case noCountrySelected = "no_country_selected"
    case noCountryMessage = "no_country_message"
    
    // MARK: - Emergency Services
    case emergency = "emergency"
    case police = "police"
    case ambulance = "ambulance"
    case fire = "fire"
    
    // MARK: - Language Settings
    case language = "language"
    case selectLanguage = "select_language"
    case searchLanguage = "search_language"
    case currentLanguage = "current_language"
    case resetToSystemDefault = "reset_to_system_default"
    case languageChanged = "language_changed"
    
    // MARK: - Security & Validation
    case securityAlert = "security_alert"
    case invalidPhoneNumber = "invalid_phone_number"
    case validationFailed = "validation_failed"
    case unableToMakeCall = "unable_to_make_call"
    
    // MARK: - Accessibility
    case callEmergency = "call_emergency"
    case callPolice = "call_police"
    case callAmbulance = "call_ambulance"
    case callFire = "call_fire"
    
    // MARK: - Widget
    case widgetName = "widget_name"
    case widgetDescription = "widget_description"
}

/// Provides translations for all app strings
enum LocalizedStrings {
    /// Translates a key to the specified locale
    static func translate(_ key: LocalizedStringKey, locale: Locale) -> String {
        // Get language code (e.g., "en" from "en-US")
        guard let languageCode = locale.language.languageCode?.identifier else {
            return key.rawValue
        }
        
        // Try exact locale match first (e.g., "en-US")
        let fullIdentifier = locale.identifier
        if let translation = translations[fullIdentifier]?[key] {
            return translation
        }
        
        // Try language code only (e.g., "en")
        if let translation = translations[languageCode]?[key] {
            return translation
        }
        
        // Fallback to English
        return translations["en"]?[key] ?? key.rawValue
    }
    
    /// All translations organized by language code
    private static let translations: [String: [LocalizedStringKey: String]] = [
        // MARK: - English
        "en": [
            .cancel: "Cancel",
            .done: "Done",
            .change: "Change",
            .search: "Search",
            .settings: "Settings",
            
            .location: "Location",
            .selectCountry: "Select Country",
            .searchCountry: "Search country",
            .noCountrySelected: "No Country Selected",
            .noCountryMessage: "Select a country manually or enable location services to automatically detect your region.",
            
            .emergency: "Emergency",
            .police: "Police",
            .ambulance: "Ambulance",
            .fire: "Fire",
            
            .language: "Language",
            .selectLanguage: "Select Language",
            .searchLanguage: "Search language",
            .currentLanguage: "Current Language",
            .resetToSystemDefault: "Reset to System Default",
            .languageChanged: "Language Changed",
            
            .securityAlert: "Security Alert",
            .invalidPhoneNumber: "Invalid emergency number format",
            .validationFailed: "Emergency number validation failed",
            .unableToMakeCall: "Unable to make phone call",
            
            .callEmergency: "Call Emergency Services",
            .callPolice: "Call Police",
            .callAmbulance: "Call Ambulance",
            .callFire: "Call Fire Department",
            
            .widgetName: "Emergency Services",
            .widgetDescription: "Quick access to emergency service numbers for your location."
        ],
        
        // MARK: - Spanish
        "es": [
            .cancel: "Cancelar",
            .done: "Hecho",
            .change: "Cambiar",
            .search: "Buscar",
            .settings: "Ajustes",
            
            .location: "Ubicación",
            .selectCountry: "Seleccionar País",
            .searchCountry: "Buscar país",
            .noCountrySelected: "Ningún País Seleccionado",
            .noCountryMessage: "Seleccione un país manualmente o active los servicios de ubicación para detectar automáticamente su región.",
            
            .emergency: "Emergencia",
            .police: "Policía",
            .ambulance: "Ambulancia",
            .fire: "Bomberos",
            
            .language: "Idioma",
            .selectLanguage: "Seleccionar Idioma",
            .searchLanguage: "Buscar idioma",
            .currentLanguage: "Idioma Actual",
            .resetToSystemDefault: "Restablecer a Predeterminado",
            .languageChanged: "Idioma Cambiado",
            
            .securityAlert: "Alerta de Seguridad",
            .invalidPhoneNumber: "Formato de número de emergencia inválido",
            .validationFailed: "Falló la validación del número de emergencia",
            .unableToMakeCall: "No se puede realizar la llamada",
            
            .callEmergency: "Llamar a Emergencias",
            .callPolice: "Llamar a la Policía",
            .callAmbulance: "Llamar a Ambulancia",
            .callFire: "Llamar a Bomberos",
            
            .widgetName: "Servicios de Emergencia",
            .widgetDescription: "Acceso rápido a números de emergencia para tu ubicación."
        ],
        
        // MARK: - French
        "fr": [
            .cancel: "Annuler",
            .done: "Terminé",
            .change: "Modifier",
            .search: "Rechercher",
            .settings: "Paramètres",
            
            .location: "Emplacement",
            .selectCountry: "Sélectionner un Pays",
            .searchCountry: "Rechercher un pays",
            .noCountrySelected: "Aucun Pays Sélectionné",
            .noCountryMessage: "Sélectionnez un pays manuellement ou activez les services de localisation pour détecter automatiquement votre région.",
            
            .emergency: "Urgence",
            .police: "Police",
            .ambulance: "Ambulance",
            .fire: "Pompiers",
            
            .language: "Langue",
            .selectLanguage: "Sélectionner la Langue",
            .searchLanguage: "Rechercher une langue",
            .currentLanguage: "Langue Actuelle",
            .resetToSystemDefault: "Réinitialiser par Défaut",
            .languageChanged: "Langue Modifiée",
            
            .securityAlert: "Alerte de Sécurité",
            .invalidPhoneNumber: "Format de numéro d'urgence invalide",
            .validationFailed: "Échec de la validation du numéro d'urgence",
            .unableToMakeCall: "Impossible de passer l'appel",
            
            .callEmergency: "Appeler les Urgences",
            .callPolice: "Appeler la Police",
            .callAmbulance: "Appeler l'Ambulance",
            .callFire: "Appeler les Pompiers",
            
            .widgetName: "Services d'Urgence",
            .widgetDescription: "Accès rapide aux numéros d'urgence pour votre emplacement."
        ],
        
        // MARK: - German
        "de": [
            .cancel: "Abbrechen",
            .done: "Fertig",
            .change: "Ändern",
            .search: "Suchen",
            .settings: "Einstellungen",
            
            .location: "Standort",
            .selectCountry: "Land Auswählen",
            .searchCountry: "Land suchen",
            .noCountrySelected: "Kein Land Ausgewählt",
            .noCountryMessage: "Wählen Sie ein Land manuell aus oder aktivieren Sie die Ortungsdienste, um Ihre Region automatisch zu erkennen.",
            
            .emergency: "Notfall",
            .police: "Polizei",
            .ambulance: "Krankenwagen",
            .fire: "Feuerwehr",
            
            .language: "Sprache",
            .selectLanguage: "Sprache Auswählen",
            .searchLanguage: "Sprache suchen",
            .currentLanguage: "Aktuelle Sprache",
            .resetToSystemDefault: "Auf Standard Zurücksetzen",
            .languageChanged: "Sprache Geändert",
            
            .securityAlert: "Sicherheitswarnung",
            .invalidPhoneNumber: "Ungültiges Notrufnummernformat",
            .validationFailed: "Validierung der Notrufnummer fehlgeschlagen",
            .unableToMakeCall: "Anruf kann nicht getätigt werden",
            
            .callEmergency: "Notruf Wählen",
            .callPolice: "Polizei Rufen",
            .callAmbulance: "Krankenwagen Rufen",
            .callFire: "Feuerwehr Rufen",
            
            .widgetName: "Notdienste",
            .widgetDescription: "Schneller Zugriff auf Notrufnummern für Ihren Standort."
        ],
        
        // MARK: - Italian
        "it": [
            .cancel: "Annulla",
            .done: "Fatto",
            .change: "Cambia",
            .search: "Cerca",
            .settings: "Impostazioni",
            
            .location: "Posizione",
            .selectCountry: "Seleziona Paese",
            .searchCountry: "Cerca paese",
            .noCountrySelected: "Nessun Paese Selezionato",
            .noCountryMessage: "Seleziona un paese manualmente o abilita i servizi di localizzazione per rilevare automaticamente la tua regione.",
            
            .emergency: "Emergenza",
            .police: "Polizia",
            .ambulance: "Ambulanza",
            .fire: "Vigili del Fuoco",
            
            .language: "Lingua",
            .selectLanguage: "Seleziona Lingua",
            .searchLanguage: "Cerca lingua",
            .currentLanguage: "Lingua Corrente",
            .resetToSystemDefault: "Ripristina Predefinita",
            .languageChanged: "Lingua Cambiata",
            
            .securityAlert: "Avviso di Sicurezza",
            .invalidPhoneNumber: "Formato numero di emergenza non valido",
            .validationFailed: "Validazione numero di emergenza fallita",
            .unableToMakeCall: "Impossibile effettuare la chiamata",
            
            .callEmergency: "Chiama Emergenza",
            .callPolice: "Chiama Polizia",
            .callAmbulance: "Chiama Ambulanza",
            .callFire: "Chiama Vigili del Fuoco",
            
            .widgetName: "Servizi di Emergenza",
            .widgetDescription: "Accesso rapido ai numeri di emergenza per la tua posizione."
        ],
        
        // MARK: - Portuguese
        "pt": [
            .cancel: "Cancelar",
            .done: "Concluído",
            .change: "Alterar",
            .search: "Pesquisar",
            .settings: "Configurações",
            
            .location: "Localização",
            .selectCountry: "Selecionar País",
            .searchCountry: "Pesquisar país",
            .noCountrySelected: "Nenhum País Selecionado",
            .noCountryMessage: "Selecione um país manualmente ou ative os serviços de localização para detectar automaticamente sua região.",
            
            .emergency: "Emergência",
            .police: "Polícia",
            .ambulance: "Ambulância",
            .fire: "Bombeiros",
            
            .language: "Idioma",
            .selectLanguage: "Selecionar Idioma",
            .searchLanguage: "Pesquisar idioma",
            .currentLanguage: "Idioma Atual",
            .resetToSystemDefault: "Redefinir para Padrão",
            .languageChanged: "Idioma Alterado",
            
            .securityAlert: "Alerta de Segurança",
            .invalidPhoneNumber: "Formato de número de emergência inválido",
            .validationFailed: "Validação do número de emergência falhou",
            .unableToMakeCall: "Não é possível fazer a chamada",
            
            .callEmergency: "Ligar para Emergência",
            .callPolice: "Ligar para Polícia",
            .callAmbulance: "Ligar para Ambulância",
            .callFire: "Ligar para Bombeiros",
            
            .widgetName: "Serviços de Emergência",
            .widgetDescription: "Acesso rápido aos números de emergência para sua localização."
        ],
        
        // MARK: - Japanese
        "ja": [
            .cancel: "キャンセル",
            .done: "完了",
            .change: "変更",
            .search: "検索",
            .settings: "設定",
            
            .location: "位置情報",
            .selectCountry: "国を選択",
            .searchCountry: "国を検索",
            .noCountrySelected: "国が選択されていません",
            .noCountryMessage: "手動で国を選択するか、位置情報サービスを有効にして自動的に地域を検出してください。",
            
            .emergency: "緊急",
            .police: "警察",
            .ambulance: "救急車",
            .fire: "消防",
            
            .language: "言語",
            .selectLanguage: "言語を選択",
            .searchLanguage: "言語を検索",
            .currentLanguage: "現在の言語",
            .resetToSystemDefault: "デフォルトにリセット",
            .languageChanged: "言語が変更されました",
            
            .securityAlert: "セキュリティ警告",
            .invalidPhoneNumber: "無効な緊急番号形式",
            .validationFailed: "緊急番号の検証に失敗しました",
            .unableToMakeCall: "電話をかけられません",
            
            .callEmergency: "緊急通報",
            .callPolice: "警察に電話",
            .callAmbulance: "救急車を呼ぶ",
            .callFire: "消防に電話",
            
            .widgetName: "緊急サービス",
            .widgetDescription: "現在地の緊急電話番号にすばやくアクセス。"
        ],
        
        // MARK: - Chinese (Simplified)
        "zh": [
            .cancel: "取消",
            .done: "完成",
            .change: "更改",
            .search: "搜索",
            .settings: "设置",
            
            .location: "位置",
            .selectCountry: "选择国家",
            .searchCountry: "搜索国家",
            .noCountrySelected: "未选择国家",
            .noCountryMessage: "手动选择国家或启用定位服务以自动检测您的地区。",
            
            .emergency: "紧急",
            .police: "警察",
            .ambulance: "救护车",
            .fire: "消防",
            
            .language: "语言",
            .selectLanguage: "选择语言",
            .searchLanguage: "搜索语言",
            .currentLanguage: "当前语言",
            .resetToSystemDefault: "重置为默认",
            .languageChanged: "语言已更改",
            
            .securityAlert: "安全警报",
            .invalidPhoneNumber: "无效的紧急号码格式",
            .validationFailed: "紧急号码验证失败",
            .unableToMakeCall: "无法拨打电话",
            
            .callEmergency: "拨打紧急电话",
            .callPolice: "拨打警察",
            .callAmbulance: "拨打救护车",
            .callFire: "拨打消防",
            
            .widgetName: "紧急服务",
            .widgetDescription: "快速访问您所在位置的紧急电话号码。"
        ],
        
        // MARK: - Korean
        "ko": [
            .cancel: "취소",
            .done: "완료",
            .change: "변경",
            .search: "검색",
            .settings: "설정",
            
            .location: "위치",
            .selectCountry: "국가 선택",
            .searchCountry: "국가 검색",
            .noCountrySelected: "선택된 국가 없음",
            .noCountryMessage: "수동으로 국가를 선택하거나 위치 서비스를 활성화하여 지역을 자동으로 감지하세요.",
            
            .emergency: "응급",
            .police: "경찰",
            .ambulance: "구급차",
            .fire: "소방",
            
            .language: "언어",
            .selectLanguage: "언어 선택",
            .searchLanguage: "언어 검색",
            .currentLanguage: "현재 언어",
            .resetToSystemDefault: "기본값으로 재설정",
            .languageChanged: "언어가 변경되었습니다",
            
            .securityAlert: "보안 경고",
            .invalidPhoneNumber: "유효하지 않은 긴급 번호 형식",
            .validationFailed: "긴급 번호 검증 실패",
            .unableToMakeCall: "전화를 걸 수 없습니다",
            
            .callEmergency: "응급 전화",
            .callPolice: "경찰에 전화",
            .callAmbulance: "구급차 호출",
            .callFire: "소방에 전화",
            
            .widgetName: "응급 서비스",
            .widgetDescription: "현재 위치의 응급 전화번호에 빠르게 액세스합니다."
        ],
        
        // MARK: - Arabic
        "ar": [
            .cancel: "إلغاء",
            .done: "تم",
            .change: "تغيير",
            .search: "بحث",
            .settings: "الإعدادات",
            
            .location: "الموقع",
            .selectCountry: "اختر البلد",
            .searchCountry: "البحث عن بلد",
            .noCountrySelected: "لم يتم اختيار بلد",
            .noCountryMessage: "اختر بلداً يدوياً أو قم بتمكين خدمات الموقع للكشف التلقائي عن منطقتك.",
            
            .emergency: "طوارئ",
            .police: "الشرطة",
            .ambulance: "الإسعاف",
            .fire: "الإطفاء",
            
            .language: "اللغة",
            .selectLanguage: "اختر اللغة",
            .searchLanguage: "البحث عن لغة",
            .currentLanguage: "اللغة الحالية",
            .resetToSystemDefault: "إعادة التعيين إلى الافتراضي",
            .languageChanged: "تم تغيير اللغة",
            
            .securityAlert: "تنبيه أمني",
            .invalidPhoneNumber: "تنسيق رقم الطوارئ غير صالح",
            .validationFailed: "فشل التحقق من رقم الطوارئ",
            .unableToMakeCall: "غير قادر على إجراء المكالمة",
            
            .callEmergency: "اتصل بالطوارئ",
            .callPolice: "اتصل بالشرطة",
            .callAmbulance: "اتصل بالإسعاف",
            .callFire: "اتصل بالإطفاء",
            
            .widgetName: "خدمات الطوارئ",
            .widgetDescription: "وصول سريع إلى أرقام الطوارئ لموقعك."
        ],
        
        // MARK: - Russian
        "ru": [
            .cancel: "Отмена",
            .done: "Готово",
            .change: "Изменить",
            .search: "Поиск",
            .settings: "Настройки",
            
            .location: "Местоположение",
            .selectCountry: "Выбрать Страну",
            .searchCountry: "Поиск страны",
            .noCountrySelected: "Страна Не Выбрана",
            .noCountryMessage: "Выберите страну вручную или включите службы определения местоположения для автоматического определения вашего региона.",
            
            .emergency: "Экстренная",
            .police: "Полиция",
            .ambulance: "Скорая",
            .fire: "Пожарная",
            
            .language: "Язык",
            .selectLanguage: "Выбрать Язык",
            .searchLanguage: "Поиск языка",
            .currentLanguage: "Текущий Язык",
            .resetToSystemDefault: "Сбросить к Стандартному",
            .languageChanged: "Язык Изменен",
            
            .securityAlert: "Предупреждение Безопасности",
            .invalidPhoneNumber: "Неверный формат номера экстренной службы",
            .validationFailed: "Проверка номера экстренной службы не удалась",
            .unableToMakeCall: "Невозможно совершить звонок",
            
            .callEmergency: "Вызвать Экстренные Службы",
            .callPolice: "Вызвать Полицию",
            .callAmbulance: "Вызвать Скорую",
            .callFire: "Вызвать Пожарную",
            
            .widgetName: "Экстренные Службы",
            .widgetDescription: "Быстрый доступ к номерам экстренных служб для вашего местоположения."
        ],
        
        // MARK: - Hindi
        "hi": [
            .cancel: "रद्द करें",
            .done: "हो गया",
            .change: "बदलें",
            .search: "खोजें",
            .settings: "सेटिंग्स",
            
            .location: "स्थान",
            .selectCountry: "देश चुनें",
            .searchCountry: "देश खोजें",
            .noCountrySelected: "कोई देश नहीं चुना गया",
            .noCountryMessage: "मैन्युअल रूप से एक देश चुनें या अपने क्षेत्र का स्वचालित रूप से पता लगाने के लिए स्थान सेवाओं को सक्षम करें।",
            
            .emergency: "आपातकाल",
            .police: "पुलिस",
            .ambulance: "एम्बुलेंस",
            .fire: "दमकल",
            
            .language: "भाषा",
            .selectLanguage: "भाषा चुनें",
            .searchLanguage: "भाषा खोजें",
            .currentLanguage: "वर्तमान भाषा",
            .resetToSystemDefault: "डिफ़ॉल्ट पर रीसेट करें",
            .languageChanged: "भाषा बदल गई",
            
            .securityAlert: "सुरक्षा चेतावनी",
            .invalidPhoneNumber: "अमान्य आपातकालीन नंबर प्रारूप",
            .validationFailed: "आपातकालीन नंबर सत्यापन विफल",
            .unableToMakeCall: "कॉल करने में असमर्थ",
            
            .callEmergency: "आपातकालीन सेवाओं को कॉल करें",
            .callPolice: "पुलिस को कॉल करें",
            .callAmbulance: "एम्बुलेंस बुलाएं",
            .callFire: "दमकल को कॉल करें",
            
            .widgetName: "आपातकालीन सेवाएं",
            .widgetDescription: "आपके स्थान के लिए आपातकालीन सेवा नंबरों तक त्वरित पहुंच।"
        ],
        
        // MARK: - Dutch
        "nl": [
            .cancel: "Annuleren",
            .done: "Klaar",
            .change: "Wijzigen",
            .search: "Zoeken",
            .settings: "Instellingen",
            
            .location: "Locatie",
            .selectCountry: "Selecteer Land",
            .searchCountry: "Zoek land",
            .noCountrySelected: "Geen Land Geselecteerd",
            .noCountryMessage: "Selecteer handmatig een land of schakel locatiediensten in om uw regio automatisch te detecteren.",
            
            .emergency: "Noodgeval",
            .police: "Politie",
            .ambulance: "Ambulance",
            .fire: "Brandweer",
            
            .language: "Taal",
            .selectLanguage: "Selecteer Taal",
            .searchLanguage: "Zoek taal",
            .currentLanguage: "Huidige Taal",
            .resetToSystemDefault: "Standaard Herstellen",
            .languageChanged: "Taal Gewijzigd",
            
            .securityAlert: "Beveiligingswaarschuwing",
            .invalidPhoneNumber: "Ongeldig noodnummerformaat",
            .validationFailed: "Validatie van noodnummer mislukt",
            .unableToMakeCall: "Kan niet bellen",
            
            .callEmergency: "Bel Hulpdiensten",
            .callPolice: "Bel Politie",
            .callAmbulance: "Bel Ambulance",
            .callFire: "Bel Brandweer",
            
            .widgetName: "Hulpdiensten",
            .widgetDescription: "Snelle toegang tot hulpdienstnummers voor uw locatie."
        ],
        
        // MARK: - Greek
        "el": [
            .cancel: "Ακύρωση",
            .done: "Τέλος",
            .change: "Αλλαγή",
            .search: "Αναζήτηση",
            .settings: "Ρυθμίσεις",
            
            .location: "Τοποθεσία",
            .selectCountry: "Επιλογή Χώρας",
            .searchCountry: "Αναζήτηση χώρας",
            .noCountrySelected: "Δεν Επιλέχθηκε Χώρα",
            .noCountryMessage: "Επιλέξτε μια χώρα χειροκίνητα ή ενεργοποιήστε τις υπηρεσίες τοποθεσίας για αυτόματο εντοπισμό της περιοχής σας.",
            
            .emergency: "Επείγον",
            .police: "Αστυνομία",
            .ambulance: "Ασθενοφόρο",
            .fire: "Πυροσβεστική",
            
            .language: "Γλώσσα",
            .selectLanguage: "Επιλογή Γλώσσας",
            .searchLanguage: "Αναζήτηση γλώσσας",
            .currentLanguage: "Τρέχουσα Γλώσσα",
            .resetToSystemDefault: "Επαναφορά Προεπιλογής",
            .languageChanged: "Η Γλώσσα Άλλαξε",
            
            .securityAlert: "Προειδοποίηση Ασφαλείας",
            .invalidPhoneNumber: "Μη έγκυρη μορφή αριθμού έκτακτης ανάγκης",
            .validationFailed: "Η επικύρωση του αριθμού έκτακτης ανάγκης απέτυχε",
            .unableToMakeCall: "Αδυναμία πραγματοποίησης κλήσης",
            
            .callEmergency: "Κλήση Υπηρεσιών Έκτακτης Ανάγκης",
            .callPolice: "Κλήση Αστυνομίας",
            .callAmbulance: "Κλήση Ασθενοφόρου",
            .callFire: "Κλήση Πυροσβεστικής",
            
            .widgetName: "Υπηρεσίες Έκτακτης Ανάγκης",
            .widgetDescription: "Γρήγορη πρόσβαση στους αριθμούς έκτακτης ανάγκης για την τοποθεσία σας."
        ],
        
        // MARK: - Turkish
        "tr": [
            .cancel: "İptal",
            .done: "Tamam",
            .change: "Değiştir",
            .search: "Ara",
            .settings: "Ayarlar",
            
            .location: "Konum",
            .selectCountry: "Ülke Seç",
            .searchCountry: "Ülke ara",
            .noCountrySelected: "Ülke Seçilmedi",
            .noCountryMessage: "Manuel olarak bir ülke seçin veya bölgenizi otomatik olarak algılamak için konum hizmetlerini etkinleştirin.",
            
            .emergency: "Acil Durum",
            .police: "Polis",
            .ambulance: "Ambulans",
            .fire: "İtfaiye",
            
            .language: "Dil",
            .selectLanguage: "Dil Seç",
            .searchLanguage: "Dil ara",
            .currentLanguage: "Geçerli Dil",
            .resetToSystemDefault: "Varsayılana Sıfırla",
            .languageChanged: "Dil Değiştirildi",
            
            .securityAlert: "Güvenlik Uyarısı",
            .invalidPhoneNumber: "Geçersiz acil durum numarası formatı",
            .validationFailed: "Acil durum numarası doğrulaması başarısız",
            .unableToMakeCall: "Arama yapılamıyor",
            
            .callEmergency: "Acil Servisleri Ara",
            .callPolice: "Polisi Ara",
            .callAmbulance: "Ambulansı Ara",
            .callFire: "İtfaiyeyi Ara",
            
            .widgetName: "Acil Servisler",
            .widgetDescription: "Konumunuz için acil servis numaralarına hızlı erişim."
        ],
        
        // MARK: - Polish
        "pl": [
            .cancel: "Anuluj",
            .done: "Gotowe",
            .change: "Zmień",
            .search: "Szukaj",
            .settings: "Ustawienia",
            
            .location: "Lokalizacja",
            .selectCountry: "Wybierz Kraj",
            .searchCountry: "Szukaj kraju",
            .noCountrySelected: "Nie Wybrano Kraju",
            .noCountryMessage: "Wybierz kraj ręcznie lub włącz usługi lokalizacji, aby automatycznie wykryć swój region.",
            
            .emergency: "Pogotowie",
            .police: "Policja",
            .ambulance: "Karetka",
            .fire: "Straż Pożarna",
            
            .language: "Język",
            .selectLanguage: "Wybierz Język",
            .searchLanguage: "Szukaj języka",
            .currentLanguage: "Obecny Język",
            .resetToSystemDefault: "Przywróć Domyślny",
            .languageChanged: "Język Zmieniony",
            
            .securityAlert: "Ostrzeżenie Bezpieczeństwa",
            .invalidPhoneNumber: "Nieprawidłowy format numeru alarmowego",
            .validationFailed: "Weryfikacja numeru alarmowego nie powiodła się",
            .unableToMakeCall: "Nie można wykonać połączenia",
            
            .callEmergency: "Zadzwoń po Pogotowie",
            .callPolice: "Zadzwoń po Policję",
            .callAmbulance: "Zadzwoń po Karetkę",
            .callFire: "Zadzwoń po Straż Pożarną",
            
            .widgetName: "Służby Ratunkowe",
            .widgetDescription: "Szybki dostęp do numerów alarmowych dla Twojej lokalizacji."
        ],
        
        // MARK: - Swedish
        "sv": [
            .cancel: "Avbryt",
            .done: "Klar",
            .change: "Ändra",
            .search: "Sök",
            .settings: "Inställningar",
            
            .location: "Plats",
            .selectCountry: "Välj Land",
            .searchCountry: "Sök land",
            .noCountrySelected: "Inget Land Valt",
            .noCountryMessage: "Välj ett land manuellt eller aktivera platstjänster för att automatiskt upptäcka din region.",
            
            .emergency: "Nödsituation",
            .police: "Polis",
            .ambulance: "Ambulans",
            .fire: "Brandkår",
            
            .language: "Språk",
            .selectLanguage: "Välj Språk",
            .searchLanguage: "Sök språk",
            .currentLanguage: "Nuvarande Språk",
            .resetToSystemDefault: "Återställ till Standard",
            .languageChanged: "Språk Ändrat",
            
            .securityAlert: "Säkerhetsvarning",
            .invalidPhoneNumber: "Ogiltigt nödnummerformat",
            .validationFailed: "Validering av nödnummer misslyckades",
            .unableToMakeCall: "Kan inte ringa",
            
            .callEmergency: "Ring Nödtjänster",
            .callPolice: "Ring Polis",
            .callAmbulance: "Ring Ambulans",
            .callFire: "Ring Brandkår",
            
            .widgetName: "Nödtjänster",
            .widgetDescription: "Snabb åtkomst till nödnummer för din plats."
        ],
        
        // MARK: - Norwegian (Bokmål)
        "nb": [
            .cancel: "Avbryt",
            .done: "Ferdig",
            .change: "Endre",
            .search: "Søk",
            .settings: "Innstillinger",
            
            .location: "Plassering",
            .selectCountry: "Velg Land",
            .searchCountry: "Søk land",
            .noCountrySelected: "Ingen Land Valgt",
            .noCountryMessage: "Velg et land manuelt eller aktiver posisjonstjenester for å automatisk oppdage din region.",
            
            .emergency: "Nødsituasjon",
            .police: "Politi",
            .ambulance: "Ambulanse",
            .fire: "Brannvesen",
            
            .language: "Språk",
            .selectLanguage: "Velg Språk",
            .searchLanguage: "Søk språk",
            .currentLanguage: "Nåværende Språk",
            .resetToSystemDefault: "Tilbakestill til Standard",
            .languageChanged: "Språk Endret",
            
            .securityAlert: "Sikkerhetsvarsel",
            .invalidPhoneNumber: "Ugyldig nødnummerformat",
            .validationFailed: "Validering av nødnummer mislyktes",
            .unableToMakeCall: "Kan ikke ringe",
            
            .callEmergency: "Ring Nødtjenester",
            .callPolice: "Ring Politi",
            .callAmbulance: "Ring Ambulanse",
            .callFire: "Ring Brannvesen",
            
            .widgetName: "Nødtjenester",
            .widgetDescription: "Rask tilgang til nødnumre for din posisjon."
        ],
        
        // MARK: - Danish
        "da": [
            .cancel: "Annuller",
            .done: "Færdig",
            .change: "Skift",
            .search: "Søg",
            .settings: "Indstillinger",
            
            .location: "Placering",
            .selectCountry: "Vælg Land",
            .searchCountry: "Søg land",
            .noCountrySelected: "Intet Land Valgt",
            .noCountryMessage: "Vælg et land manuelt eller aktiver placeringstjenester for automatisk at registrere din region.",
            
            .emergency: "Nødsituation",
            .police: "Politi",
            .ambulance: "Ambulance",
            .fire: "Brandvæsen",
            
            .language: "Sprog",
            .selectLanguage: "Vælg Sprog",
            .searchLanguage: "Søg sprog",
            .currentLanguage: "Nuværende Sprog",
            .resetToSystemDefault: "Nulstil til Standard",
            .languageChanged: "Sprog Ændret",
            
            .securityAlert: "Sikkerhedsadvarsel",
            .invalidPhoneNumber: "Ugyldigt nødnummerformat",
            .validationFailed: "Validering af nødnummer mislykkedes",
            .unableToMakeCall: "Kan ikke foretage opkald",
            
            .callEmergency: "Ring Nødtjenester",
            .callPolice: "Ring Politi",
            .callAmbulance: "Ring Ambulance",
            .callFire: "Ring Brandvæsen",
            
            .widgetName: "Nødtjenester",
            .widgetDescription: "Hurtig adgang til nødnumre for din placering."
        ],
        
        // MARK: - Finnish
        "fi": [
            .cancel: "Peruuta",
            .done: "Valmis",
            .change: "Vaihda",
            .search: "Etsi",
            .settings: "Asetukset",
            
            .location: "Sijainti",
            .selectCountry: "Valitse Maa",
            .searchCountry: "Etsi maata",
            .noCountrySelected: "Ei Valittua Maata",
            .noCountryMessage: "Valitse maa manuaalisesti tai ota sijaintipalvelut käyttöön alueesi automaattiseksi tunnistamiseksi.",
            
            .emergency: "Hätätilanne",
            .police: "Poliisi",
            .ambulance: "Ambulanssi",
            .fire: "Palokunta",
            
            .language: "Kieli",
            .selectLanguage: "Valitse Kieli",
            .searchLanguage: "Etsi kieltä",
            .currentLanguage: "Nykyinen Kieli",
            .resetToSystemDefault: "Palauta Oletusarvo",
            .languageChanged: "Kieli Vaihdettu",
            
            .securityAlert: "Turvallisuusvaroitus",
            .invalidPhoneNumber: "Virheellinen hätänumeron muoto",
            .validationFailed: "Hätänumeron vahvistus epäonnistui",
            .unableToMakeCall: "Puhelua ei voi soittaa",
            
            .callEmergency: "Soita Hätäpalveluihin",
            .callPolice: "Soita Poliisille",
            .callAmbulance: "Soita Ambulanssi",
            .callFire: "Soita Palokunnalle",
            
            .widgetName: "Hätäpalvelut",
            .widgetDescription: "Nopea pääsy hätänumeroihin sijaintisi perusteella."
        ],
        
        // MARK: - Ukrainian
        "uk": [
            .cancel: "Скасувати",
            .done: "Готово",
            .change: "Змінити",
            .search: "Пошук",
            .settings: "Налаштування",
            
            .location: "Місцезнаходження",
            .selectCountry: "Вибрати Країну",
            .searchCountry: "Шукати країну",
            .noCountrySelected: "Країну Не Вибрано",
            .noCountryMessage: "Виберіть країну вручну або увімкніть служби визначення місцезнаходження для автоматичного визначення вашого регіону.",
            
            .emergency: "Екстрена",
            .police: "Поліція",
            .ambulance: "Швидка",
            .fire: "Пожежна",
            
            .language: "Мова",
            .selectLanguage: "Вибрати Мову",
            .searchLanguage: "Шукати мову",
            .currentLanguage: "Поточна Мова",
            .resetToSystemDefault: "Скинути до Стандартної",
            .languageChanged: "Мову Змінено",
            
            .securityAlert: "Попередження Безпеки",
            .invalidPhoneNumber: "Невірний формат номера екстреної служби",
            .validationFailed: "Перевірка номера екстреної служби не вдалася",
            .unableToMakeCall: "Неможливо здійснити дзвінок",
            
            .callEmergency: "Викликати Екстрені Служби",
            .callPolice: "Викликати Поліцію",
            .callAmbulance: "Викликати Швидку",
            .callFire: "Викликати Пожежну",
            
            .widgetName: "Екстрені Служби",
            .widgetDescription: "Швидкий доступ до номерів екстрених служб для вашого місцезнаходження."
        ]
    ]
}
