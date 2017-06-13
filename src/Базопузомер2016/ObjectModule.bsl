﻿
////////////////////////////////////////////////////////////////////////////////
// ОСНОВНЫЕ ПРОЦЕДУРЫ ФОРМИРОВАНИЯ ОТЧЕТА

Процедура ВывестиРазделОсновногоОтчета(ТабДок, Макет, ОблПодзаголовок, МетаМетка)
	
	// инициализация локальных данных
	Если Лев(МетаМетка, 3) = "Рег" Тогда
		ОблШапка = Макет.ПолучитьОбласть("ШапкаРег");
		ОблСтрока = Макет.ПолучитьОбласть("СтрокаРег");
		ОблПодвал = Макет.ПолучитьОбласть("ПодвалРег");
	ИначеЕсли МетаМетка = "Спр" ИЛИ МетаМетка = "ПВХ" Тогда
		Если НеВыводитьИнформациюОТабличныхЧастях Тогда
			ОблШапка = Макет.ПолучитьОбласть("ШапкаСпр|Начало");
			ОблСтрока = Макет.ПолучитьОбласть("СтрокаСпр|Начало");
			ОблПодвал = Макет.ПолучитьОбласть("ПодвалСпр|Начало");
		Иначе
			ОблШапка = Макет.ПолучитьОбласть("ШапкаСпр");
			ОблСтрока = Макет.ПолучитьОбласть("СтрокаСпр");
			ОблПодвал = Макет.ПолучитьОбласть("ПодвалСпр");
		КонецЕсли;
	ИначеЕсли МетаМетка = "ПС" Тогда
		Если НеВыводитьИнформациюОТабличныхЧастях Тогда
			ОблШапка = Макет.ПолучитьОбласть("ШапкаПС|Начало1");
			ОблСтрока = Макет.ПолучитьОбласть("СтрокаПС|Начало1");
			ОблПодвал = Макет.ПолучитьОбласть("ПодвалПС|Начало1");
		Иначе
			ОблШапка = Макет.ПолучитьОбласть("ШапкаПС");
			ОблСтрока = Макет.ПолучитьОбласть("СтрокаПС");
			ОблПодвал = Макет.ПолучитьОбласть("ПодвалПС");
		КонецЕсли;
	ИначеЕсли МетаМетка = "ПВР" ИЛИ МетаМетка = "БП" ИЛИ МетаМетка = "Зад" ИЛИ МетаМетка = "ПО" Тогда
		ОблШапка = Макет.ПолучитьОбласть("ШапкаПС");
		ОблСтрока = Макет.ПолучитьОбласть("СтрокаПС");
		ОблПодвал = Макет.ПолучитьОбласть("ПодвалПС");
	ИначеЕсли МетаМетка = "Док" Тогда
		Если НеВыводитьИнформациюОТабличныхЧастях Тогда
			ОблШапка = Макет.ПолучитьОбласть("ШапкаДок|Начало");
			ОблСтрока = Макет.ПолучитьОбласть("СтрокаДок|Начало");
			ОблПодвал = Макет.ПолучитьОбласть("ПодвалДок|Начало");
		Иначе
			ОблШапка = Макет.ПолучитьОбласть("ШапкаДок");
			ОблСтрока = Макет.ПолучитьОбласть("СтрокаДок");
			ОблПодвал = Макет.ПолучитьОбласть("ПодвалДок");
		КонецЕсли;
	Иначе
		ОблШапка = Макет.ПолучитьОбласть("Шапка" + МетаМетка);
		ОблСтрока = Макет.ПолучитьОбласть("Строка" + МетаМетка);
		ОблПодвал = Макет.ПолучитьОбласть("Подвал" + МетаМетка);
	КонецЕсли;
	ОблШапкаТЧ = Макет.ПолучитьОбласть("ШапкаТЧ");
	ОблСтрокаТЧ = Макет.ПолучитьОбласть("СтрокаТЧ");
	ОблПодвалТЧ = Макет.ПолучитьОбласть("ПодвалТЧ");
	Запрос = Новый Запрос;
	ТаблицаРезультата = СоздатьТаблицуРезультата(МетаМетка);
	ПоляСорт = ПолучитьПоляСортировки();
	
	// сбор данных
	ТипМетаданных = ПолучитьТипМетаданныхПоМетаметке(МетаМетка);
	Для Каждого МетаОбъект Из Метаданные[ТипМетаданных] Цикл
		
		Запрос.Текст = ТекстЗапросаПоМетаданному(МетаМетка, МетаОбъект.Имя);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			
			КоличествоОбъектов = Выборка.Количество;
			
			НоваяСтрока = ТаблицаРезультата.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			НоваяСтрока.Имя = МетаОбъект.Имя;
			НоваяСтрока.Синоним = МетаОбъект.Синоним;
			
			ТаблицаТЧ = ЗаполнитьСведенияОТабличныхЧастях(МетаОбъект, МетаМетка, КоличествоОбъектов);
			НоваяСтрока.ТабличныеЧасти = ТаблицаТЧ;
			Если ТаблицаТЧ <> Неопределено Тогда
				НоваяСтрока.СтрокТЧ = ТаблицаТЧ.Итог("Количество");
				НоваяСтрока.СтрокТЧНаОбъект = ?(КоличествоОбъектов = 0, 0, НоваяСтрока.СтрокТЧ / КоличествоОбъектов);
				НоваяСтрока.Пузатость = КоличествоОбъектов + НоваяСтрока.СтрокТЧ;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ТаблицаРезультата.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаРезультата.Сортировать(ПоляСорт);
	
	// вывод данных
	ОблПодзаголовок.Параметры.Подзаголовок = ПолучитьПодзаголовокПоМетаметке(МетаМетка) + " (" + ТаблицаРезультата.Количество() + ")";
	ТабДок.Вывести(ОблПодзаголовок);
	
	ТабДок.НачатьГруппуСтрок(, Ложь);
	ОблШапка.Параметры.ПодзаголовокШапки = ПолучитьПодзаголовокШапкиПоМетаметке(МетаМетка);
	ОблШапка.Параметры.Количество = Формат(ТаблицаРезультата.Итог("Количество"), "ЧЦ=15; ЧДЦ=; ЧРГ=' '");
	ТабДок.Вывести(ОблШапка);
	
	Для Каждого СтрокаТаблицы Из ТаблицаРезультата Цикл
		
		ОблСтрока.Параметры.Заполнить(СтрокаТаблицы);
		ОблСтрока.Параметры.ИмяОбъекта = СформироватьИмяОбъекта(СтрокаТаблицы.Имя, СтрокаТаблицы.Синоним);
		ОблСтрока.Параметры.ДанныеРасшифровки = "" + ПолучитьИмяТаблицыЗапросаПоМетаметке(МетаМетка) + "." + СтрокаТаблицы.Имя + ".ФормаСписка";
		Если МетаМетка = "Спр" ИЛИ МетаМетка = "ПВХ" Тогда
			ЯчейкаГрупп = ОблСтрока.Область("ЯчейкаГрупп");
			ЯчейкаГрупп.ЦветФона = ?(СтрокаТаблицы.Иерархический, WebЦвета.Белый, WebЦвета.СеребристоСерый);
		КонецЕсли;
		ТабДок.Вывести(ОблСтрока);
		
		ТабТЧ = СтрокаТаблицы.ТабличныеЧасти;
		Если ТабТЧ <> Неопределено И ТабТЧ.Количество() > 0 Тогда // ТипЗнч(ТабТЧ) = Тип("ТаблицаЗначений")
			ТабТЧ.Сортировать(ПоляСорт);
			ТабДок.НачатьГруппуСтрок(, Ложь);
			ТабДок.Вывести(ОблШапкаТЧ);
			Для Каждого СтрокаТаблицыТЧ Из ТабТЧ Цикл
				ОблСтрокаТЧ.Параметры.Заполнить(СтрокаТаблицыТЧ);
				ОблСтрокаТЧ.Параметры.ИмяОбъекта = СформироватьИмяОбъекта(СтрокаТаблицыТЧ.Имя, СтрокаТаблицыТЧ.Синоним);
				ТабДок.Вывести(ОблСтрокаТЧ);
			КонецЦикла;
			ТабДок.Вывести(ОблПодвалТЧ);
			ТабДок.ЗакончитьГруппуСтрок();
		КонецЕсли;
		
	КонецЦикла;
	
	ТабДок.Вывести(ОблПодвал);
	ТабДок.ЗакончитьГруппуСтрок();
	
КонецПроцедуры

Процедура ВывестиРазделОтчетаПоПериодам(ТабДок, Макет, ОблПодзаголовок, МетаМетка, пПериод)
	
	// инициализация локальных данных
	ОблШапка = Макет.ПолучитьОбласть("ШапкаПериод");
	ОблСтрока = Макет.ПолучитьОбласть("СтрокаПериод");
	ОблПодвал = Макет.ПолучитьОбласть("ПодвалПериод");
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачПериода", НачалоДня(пПериод.ДатаНачала));
	Запрос.УстановитьПараметр("КонПериода", КонецДня(пПериод.ДатаОкончания));
	ТаблицаРезультата = СоздатьТаблицуРезультатаПоПериодам();
	ПоляСорт = ПолучитьПоляСортировки();
	
	// сбор данных
	ТипМетаданных = ПолучитьТипМетаданныхПоМетаметке(МетаМетка);
	Для Каждого МетаОбъект Из Метаданные[ТипМетаданных] Цикл
		
		Если МетаМетка = "РегС" И Метаданные.РегистрыСведений[МетаОбъект.Имя].ПериодичностьРегистраСведений = Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический Тогда
			Продолжить;
		КонецЕсли;
		
		Запрос.Текст = ТекстЗапросаПоМетаданномуПоПериодам(МетаМетка, МетаОбъект.Имя);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Если НЕ ВыводитьПустыеЗначения И (ТипЗнч(Выборка.Количество) <> Тип("Число") ИЛИ Выборка.Количество = 0) Тогда
				Продолжить;
			КонецЕсли;
			НоваяСтрока = ТаблицаРезультата.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			НоваяСтрока.Имя = МетаОбъект.Имя;
			НоваяСтрока.Синоним = МетаОбъект.Синоним;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ТаблицаРезультата.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаРезультата.Сортировать(ПоляСорт);
	
	// вывод данных
	ОблПодзаголовок.Параметры.Подзаголовок = ПолучитьПодзаголовокПоМетаметке(МетаМетка) + " (" + ТаблицаРезультата.Количество() + ")";
	ТабДок.Вывести(ОблПодзаголовок);
	
	ТабДок.НачатьГруппуСтрок(, Ложь);
	ОблШапка.Параметры.ПодзаголовокШапки = ПолучитьПодзаголовокШапкиПоМетаметке(МетаМетка);
	ОблШапка.Параметры.Количество = Формат(ТаблицаРезультата.Итог("Количество"), "ЧЦ=15; ЧДЦ=; ЧРГ=' '");
	ТабДок.Вывести(ОблШапка);
	
	Для Каждого СтрокаТаблицы Из ТаблицаРезультата Цикл
		ОблСтрока.Параметры.Заполнить(СтрокаТаблицы);
		ОблСтрока.Параметры.ИмяОбъекта = СформироватьИмяОбъекта(СтрокаТаблицы.Имя, СтрокаТаблицы.Синоним);
		ОблСтрока.Параметры.ДанныеРасшифровки = "" + ПолучитьИмяТаблицыЗапросаПоМетаметке(МетаМетка) + "." + СтрокаТаблицы.Имя + ".ФормаСписка";
		ТабДок.Вывести(ОблСтрока);
	КонецЦикла;
	
	ТабДок.Вывести(ОблПодвал);
	ТабДок.ЗакончитьГруппуСтрок();
	
КонецПроцедуры

Процедура ВывестиРазделОтчетаСтруктура(ТабДок, Макет, Области, МетаМетка, РасчетОбъема, ИменаСУБД)
	
	// инициализация локальных данных
	ОблПодзаголовок = Области.Подзаголовок1;
	ОблПодзаголовок2 = Области.Подзаголовок2;
	ОблШапка = Области.Шапка;
	ОблСтрока = Области.Строка;
	ОблПодвал = Области.Подвал;
	ОблиШапка = Области.иШапка;
	ОблиСтрока = Области.иСтрока;
	
	ТаблицаРезультата = Новый ТаблицаЗначений;
	ТаблицаРезультата.Колонки.Добавить("Имя", тСтрока(150));
	ТаблицаРезультата.Колонки.Добавить("Синоним", тСтрока(150));
	ТаблицаРезультата.Колонки.Добавить("тзТаблицы");
	ТаблицаРезультата.Колонки.Добавить("Количество", тЧисло(19, 2));
	
	ТаблицаОбъекта = Новый ТаблицаЗначений;
	ТаблицаОбъекта.Колонки.Добавить("Метаданные", тСтрока(150));
	ТаблицаОбъекта.Колонки.Добавить("ИмяТаблицыХранения", тСтрока(150));
	ТаблицаОбъекта.Колонки.Добавить("Назначение", тСтрока(150));
	ТаблицаОбъекта.Колонки.Добавить("тзИндексы");
	ТаблицаОбъекта.Колонки.Добавить("Количество", тЧисло(19, 2));
	
	ТаблицаИндексов = Новый ТаблицаЗначений;
	ТаблицаИндексов.Колонки.Добавить("ИмяИндексаХранения", тСтрока(150));
	ТаблицаИндексов.Колонки.Добавить("Количество", тЧисло(19, 2));
	
	ПоляСорт = ПолучитьПоляСортировки();
	
	// сбор данных
	ТипМетаданных = ПолучитьТипМетаданныхПоМетаметке(МетаМетка);
	Для Каждого МетаОбъект Из Метаданные[ТипМетаданных] Цикл
		
		МассивМетаданных = Новый Массив;
		МассивМетаданных.Добавить(МетаОбъект);
		СтруктураБД = ПолучитьСтруктуруХраненияБазыДанных(МассивМетаданных, ИменаСУБД);
		
		ТаблицаОбъекта.Очистить();
		Для Каждого СтрокаОбъект Из СтруктураБД Цикл
			
			НоваяСтрока = ТаблицаОбъекта.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаОбъект);
			НоваяСтрока.Количество = ПолучитьОбъемТаблицыСУБД(НоваяСтрока.ИмяТаблицыХранения, РасчетОбъема);
			
			ТаблицаИндексов.Очистить();
			Для Каждого СтрокаИндекс Из СтрокаОбъект.Индексы Цикл
				индНоваяСтрока = ТаблицаИндексов.Добавить();
				индНоваяСтрока.ИмяИндексаХранения = СтрокаИндекс.ИмяИндексаХранения;
				индНоваяСтрока.Количество = ПолучитьОбъемТаблицыСУБД(индНоваяСтрока.ИмяИндексаХранения, РасчетОбъема);
			КонецЦикла;
			
			НоваяСтрока.Количество = НоваяСтрока.Количество + ТаблицаИндексов.Итог("Количество");
			НоваяСтрока.тзИндексы = ТаблицаИндексов.Скопировать();
			
		КонецЦикла;
		
		ТаблицаОбъекта.Сортировать("Количество убыв");
		резНоваяСтрока = ТаблицаРезультата.Добавить();
		резНоваяСтрока.Имя = МетаОбъект.Имя;
		резНоваяСтрока.Синоним = МетаОбъект.Синоним;
		резНоваяСтрока.тзТаблицы = ТаблицаОбъекта.Скопировать();
		резНоваяСтрока.Количество = ТаблицаОбъекта.Итог("Количество");
		
	КонецЦикла;
	
	//Если ТаблицаРезультата.Итог("Количество") = 0 Тогда
	//	Возврат;
	//КонецЕсли;
	
	ТаблицаРезультата.Сортировать(ПоляСорт);
	
	// вывод данных
	ОблПодзаголовок.Параметры.Подзаголовок = ПолучитьПодзаголовокПоМетаметке(МетаМетка);
	Если РасчетОбъема Тогда
		ОблПодзаголовок.Параметры.Количество = ТаблицаРезультата.Итог("Количество");
	КонецЕсли;
	ТабДок.Вывести(ОблПодзаголовок);
	
	ТабДок.НачатьГруппуСтрок(, Ложь);
	
	Для Каждого СтрокаТаблицы Из ТаблицаРезультата Цикл
		
		ОблПодзаголовок2.Параметры.Подзаголовок = СформироватьИмяОбъекта(СтрокаТаблицы.Имя, СтрокаТаблицы.Синоним);
		ОблПодзаголовок2.Параметры.ДанныеРасшифровки = "" + ПолучитьИмяТаблицыЗапросаПоМетаметке(МетаМетка) + "." + СтрокаТаблицы.Имя + ".ФормаСписка";
		Если РасчетОбъема Тогда
			ОблПодзаголовок2.Параметры.Количество = СтрокаТаблицы.Количество;
		КонецЕсли;
		ТабДок.Вывести(ОблПодзаголовок2);
		
		ТабДок.НачатьГруппуСтрок(, Ложь);
		Для Каждого СтрокаОбъект Из СтрокаТаблицы.тзТаблицы Цикл
			
			ОблСтрока.Параметры.Заполнить(СтрокаОбъект);
			ТабДок.Вывести(ОблСтрока);
			
			Если СтрокаОбъект.тзИндексы.Количество() > 0 Тогда
				ТабДок.НачатьГруппуСтрок(, Ложь);
				ТабДок.Вывести(ОблиШапка);
				Для Каждого СтрокаИндекс Из СтрокаОбъект.тзИндексы Цикл
					ОблиСтрока.Параметры.Заполнить(СтрокаИндекс);
					ТабДок.Вывести(ОблиСтрока);
				КонецЦикла;
				ТабДок.ЗакончитьГруппуСтрок();
			КонецЕсли;
			
		КонецЦикла;
		ТабДок.ЗакончитьГруппуСтрок();
		
	КонецЦикла;
	
	ТабДок.Вывести(ОблПодвал);
	ТабДок.ЗакончитьГруппуСтрок();
	
КонецПроцедуры

// Формирует табличный документ готового отчета
//
// Параметры
//
// Возвращаемое значение:
//   ТабличныйДокумент   - Сформированный отчет
//
//
Функция СформироватьМакетТаблицыОтчета(пПериод) Экспорт
	
	ТабДок = Новый ТабличныйДокумент;
	
	Если ВидОтчета = "Основной" Тогда
		
		Макет = ПолучитьМакет("ОсновнойОтчет");
		ОблЗаголовок = Макет.ПолучитьОбласть("Заголовок");
		ОблПодзаголовок = Макет.ПолучитьОбласть("Подзаголовок");
		ТабДок.Вывести(ОблЗаголовок);
		
		ВывестиРазделОсновногоОтчета(ТабДок, Макет, ОблПодзаголовок, "ПО");
		ВывестиРазделОсновногоОтчета(ТабДок, Макет, ОблПодзаголовок, "Спр");
		ВывестиРазделОсновногоОтчета(ТабДок, Макет, ОблПодзаголовок, "Док");
		ВывестиРазделОсновногоОтчета(ТабДок, Макет, ОблПодзаголовок, "ПВХ");
		ВывестиРазделОсновногоОтчета(ТабДок, Макет, ОблПодзаголовок, "ПС");
		ВывестиРазделОсновногоОтчета(ТабДок, Макет, ОблПодзаголовок, "ПВР");
		
		ВывестиРазделОсновногоОтчета(ТабДок, Макет, ОблПодзаголовок, "РегС");
		ВывестиРазделОсновногоОтчета(ТабДок, Макет, ОблПодзаголовок, "РегН");
		ВывестиРазделОсновногоОтчета(ТабДок, Макет, ОблПодзаголовок, "РегБ");
		ВывестиРазделОсновногоОтчета(ТабДок, Макет, ОблПодзаголовок, "РегР");
		
		ВывестиРазделОсновногоОтчета(ТабДок, Макет, ОблПодзаголовок, "БП");
		ВывестиРазделОсновногоОтчета(ТабДок, Макет, ОблПодзаголовок, "Зад");
		
	ИначеЕсли ВидОтчета = "ПоПериодам" Тогда
		
		Макет = ПолучитьМакет("ОсновнойОтчет");
		ОблЗаголовок = Макет.ПолучитьОбласть("Заголовок");
		ОблПодзаголовок = Макет.ПолучитьОбласть("Подзаголовок");
		ТабДок.Вывести(ОблЗаголовок);
		
		ВывестиРазделОтчетаПоПериодам(ТабДок, Макет, ОблПодзаголовок, "Док", пПериод);
		
		ВывестиРазделОтчетаПоПериодам(ТабДок, Макет, ОблПодзаголовок, "РегС", пПериод);
		ВывестиРазделОтчетаПоПериодам(ТабДок, Макет, ОблПодзаголовок, "РегН", пПериод);
		ВывестиРазделОтчетаПоПериодам(ТабДок, Макет, ОблПодзаголовок, "РегБ", пПериод);
		ВывестиРазделОтчетаПоПериодам(ТабДок, Макет, ОблПодзаголовок, "РегР", пПериод);
		
		ВывестиРазделОтчетаПоПериодам(ТабДок, Макет, ОблПодзаголовок, "БП", пПериод);
		ВывестиРазделОтчетаПоПериодам(ТабДок, Макет, ОблПодзаголовок, "Зад", пПериод);
		
	Иначе
		
		Макет = ПолучитьМакет("СтруктураБД");
		РасчетОбъема = ЭтоКлиентСервер И РассчитыватьОбъемТаблицБД;
		ОблЗаголовок = Макет.ПолучитьОбласть("Заголовок");
		ОблЗаголовок.Параметры.ПутьИБ = СтрокаСоединенияИнформационнойБазы();
		ТабДок.Вывести(ОблЗаголовок);
		
		СуффиксИмени = ?(РасчетОбъема, "", "|Основной");
		иСуффиксИмени = ?(РасчетОбъема, "", "|иОсновной");
		Области = Новый Структура();
		Области.Вставить("Подзаголовок1", Макет.ПолучитьОбласть("Подзаголовок1"+СуффиксИмени));
		Области.Вставить("Подзаголовок2", Макет.ПолучитьОбласть("Подзаголовок2"+СуффиксИмени));
		Области.Вставить("Шапка", Макет.ПолучитьОбласть("Шапка"+СуффиксИмени));
		Области.Вставить("Строка", Макет.ПолучитьОбласть("Строка"+СуффиксИмени));
		Области.Вставить("Подвал", Макет.ПолучитьОбласть("Подвал"+СуффиксИмени));
		Области.Вставить("иШапка", Макет.ПолучитьОбласть("иШапка"+иСуффиксИмени));
		Области.Вставить("иСтрока", Макет.ПолучитьОбласть("иСтрока"+иСуффиксИмени));
		
		ТабДок.Вывести(Области.Шапка);
		
		ВывестиРазделОтчетаСтруктура(ТабДок, Макет, Области, "ПО",  РасчетОбъема, СтруктураВТерминахСУБД);
		ВывестиРазделОтчетаСтруктура(ТабДок, Макет, Области, "Спр", РасчетОбъема, СтруктураВТерминахСУБД);
		ВывестиРазделОтчетаСтруктура(ТабДок, Макет, Области, "Док", РасчетОбъема, СтруктураВТерминахСУБД);
		ВывестиРазделОтчетаСтруктура(ТабДок, Макет, Области, "ПВХ", РасчетОбъема, СтруктураВТерминахСУБД);
		ВывестиРазделОтчетаСтруктура(ТабДок, Макет, Области, "ПС",  РасчетОбъема, СтруктураВТерминахСУБД);
		ВывестиРазделОтчетаСтруктура(ТабДок, Макет, Области, "ПВР", РасчетОбъема, СтруктураВТерминахСУБД);
		
		ВывестиРазделОтчетаСтруктура(ТабДок, Макет, Области, "РегС", РасчетОбъема, СтруктураВТерминахСУБД);
		ВывестиРазделОтчетаСтруктура(ТабДок, Макет, Области, "РегН", РасчетОбъема, СтруктураВТерминахСУБД);
		ВывестиРазделОтчетаСтруктура(ТабДок, Макет, Области, "РегБ", РасчетОбъема, СтруктураВТерминахСУБД);
		ВывестиРазделОтчетаСтруктура(ТабДок, Макет, Области, "РегР", РасчетОбъема, СтруктураВТерминахСУБД);
		
		ВывестиРазделОтчетаСтруктура(ТабДок, Макет, Области, "БП",  РасчетОбъема, СтруктураВТерминахСУБД);
		ВывестиРазделОтчетаСтруктура(ТабДок, Макет, Области, "Зад", РасчетОбъема, СтруктураВТерминахСУБД);
		
	КонецЕсли;
	
	Возврат ТабДок;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СБОР ДАННЫХ ДЛЯ ОТЧЕТА

// для основного отчета

Функция ОбластиПоискаРегистраСведений()
	
	Результат = Новый Массив;
	Результат.Добавить("Измерения");
	Результат.Добавить("Ресурсы");
	Результат.Добавить("Реквизиты");
	
	Возврат Результат;
	
КонецФункции

Функция ТекстЗапросаПоМетаданному(МетаМетка, ИмяТаблицы)
	
	пИерархияГруппИЭлементов = Метаданные.СвойстваОбъектов.ВидИерархии.ИерархияГруппИЭлементов;
	ИмяМенеджераТаблицы = ПолучитьИмяТаблицыЗапросаПоМетаметке(МетаМетка);
	ПолеСуммирования = "";
	ТекстЗапроса = "";
	ПриводитьСтроковоеПоле = Ложь;
	
	Если МетаМетка = "Спр" ИЛИ МетаМетка = "ПВХ" Тогда
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(ТаблицаДанных.Ссылка) КАК Количество,
		|	СУММА(%Иерархия%) КАК Групп,
		|	СУММА(ВЫБОР
		|			КОГДА ТаблицаДанных.ПометкаУдаления
		|				ТОГДА 1
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК Помеченных,
		|	%ИерархияЗначение% КАК Иерархический
		|ИЗ
		|	" + ИмяМенеджераТаблицы + "." + ИмяТаблицы + " КАК ТаблицаДанных
		|";
		
		ПризнакИерархичности = Ложь;
		Если МетаМетка = "Спр" Тогда
			ПризнакИерархичности = (Метаданные.Справочники[ИмяТаблицы].Иерархический И Метаданные.Справочники[ИмяТаблицы].ВидИерархии = пИерархияГруппИЭлементов);
		ИначеЕсли МетаМетка = "ПВХ" Тогда
			ПризнакИерархичности = (Метаданные.ПланыВидовХарактеристик[ИмяТаблицы].Иерархический);
		КонецЕсли;
		
		Если ПризнакИерархичности Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%Иерархия%", "ВЫБОР КОГДА ТаблицаДанных.ЭтоГруппа ТОГДА 1 ИНАЧЕ 0 КОНЕЦ");
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ИерархияЗначение%", "ИСТИНА");
		Иначе
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%Иерархия%", "0");
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ИерархияЗначение%", "ЛОЖЬ");
		КонецЕсли;
		
	ИначеЕсли МетаМетка = "Док" Тогда
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(ТаблицаДанных.Ссылка) КАК Количество,
		|	СУММА(ВЫБОР
		|			КОГДА ТаблицаДанных.Проведен
		|				ТОГДА 1
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК Проведенных,
		|	СУММА(ВЫБОР
		|			КОГДА ТаблицаДанных.ПометкаУдаления
		|				ТОГДА 1
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК Помеченных
		|ИЗ
		|	Документ." + ИмяТаблицы + " КАК ТаблицаДанных
		|";
		
	ИначеЕсли МетаМетка = "ПС" ИЛИ МетаМетка = "ПВР" ИЛИ МетаМетка = "БП" ИЛИ МетаМетка = "Зад" ИЛИ МетаМетка = "ПО" Тогда
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(ТаблицаДанных.Ссылка) КАК Количество,
		|	СУММА(ВЫБОР
		|			КОГДА ТаблицаДанных.ПометкаУдаления
		|				ТОГДА 1
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК Помеченных
		|ИЗ
		|	" + ИмяМенеджераТаблицы + "." + ИмяТаблицы + " КАК ТаблицаДанных
		|";
		
	ИначеЕсли Лев(МетаМетка, 3) = "Рег" Тогда
		
		ПолеСуммирования = "Регистратор";
		
		Если МетаМетка = "РегС" Тогда
			
			МетаРС = Метаданные.РегистрыСведений[ИмяТаблицы];
			ПолеСуммирования = "";
			
			Если МетаРС.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.ПодчинениеРегистратору Тогда
				ПолеСуммирования = "Регистратор";
			ИначеЕсли МетаРС.ПериодичностьРегистраСведений <> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический Тогда
				ПолеСуммирования = "Период";
			КонецЕсли;
			
			ОбластиПоиска = ОбластиПоискаРегистраСведений();
			Для Каждого ОбластьПоиска Из ОбластиПоиска Цикл
				
				Если НЕ ПустаяСтрока(ПолеСуммирования) Тогда
					Прервать;
				КонецЕсли;
				Если МетаРС[ОбластьПоиска].Количество() = 0 Тогда
					Продолжить;
				КонецЕсли;
					
				КоллекцияПолей = МетаРС[ОбластьПоиска];
				ВерхнийИндекс = МетаРС[ОбластьПоиска].Количество() - 1;
				Инд = 0;
				Для Инд = 0 По ВерхнийИндекс Цикл
					ПроверяемоеПоле = КоллекцияПолей.Получить(Инд);
					Если ПроверяемоеПоле.Тип.СодержитТип(Тип("ХранилищеЗначения")) Тогда
						Продолжить;
					КонецЕсли;
					Если ПроверяемоеПоле.Тип.СодержитТип(Тип("Строка")) Тогда
						ПриводитьСтроковоеПоле = Истина;
					КонецЕсли;
					ПолеСуммирования = ПроверяемоеПоле.Имя;
					Прервать;
				КонецЦикла;
				
			КонецЦикла;
			
			//Если МетаРС.Измерения.Количество() > 0 Тогда
			//	ПроверяемоеПоле = МетаРС.Измерения[0];
			//	Если ПроверяемоеПоле.Тип.СодержитТип(Тип("Строка")) Тогда
			//		ПриводитьСтроковоеПоле = Истина;
			//	КонецЕсли;
			//	ПолеСуммирования = ПроверяемоеПоле.Имя;
			//ИначеЕсли МетаРС.Ресурсы.Количество() > 0 Тогда
			//	ПроверяемоеПоле = МетаРС.Ресурсы[0];
			//	Если ПроверяемоеПоле.Тип.СодержитТип(Тип("Строка")) Тогда
			//		ПриводитьСтроковоеПоле = Истина;
			//	КонецЕсли;
			//	ПолеСуммирования = ПроверяемоеПоле.Имя;
			//ИначеЕсли МетаРС.Реквизиты.Количество() > 0 Тогда
			//	ПроверяемоеПоле = МетаРС.Реквизиты[0];
			//	Если ПроверяемоеПоле.Тип.СодержитТип(Тип("Строка")) Тогда
			//		ПриводитьСтроковоеПоле = Истина;
			//	КонецЕсли;
			//	ПолеСуммирования = ПроверяемоеПоле.Имя;
			//КонецЕсли;
			
			Если ПустаяСтрока(ПолеСуммирования) Тогда
				Возврат "ВЫБРАТЬ 0 КАК Количество";
			КонецЕсли;
			
		КонецЕсли;
		
		Если ПриводитьСтроковоеПоле Тогда
			
			ТекстЗапроса = 
			"ВЫБРАТЬ
			|	КОЛИЧЕСТВО(ВЫРАЗИТЬ(ТаблицаДанных." + ПолеСуммирования + " КАК Строка(1))) КАК Количество
			|ИЗ
			|	" + ИмяМенеджераТаблицы + "." + ИмяТаблицы + " КАК ТаблицаДанных
			|";
			
		Иначе
			
			ТекстЗапроса = 
			"ВЫБРАТЬ
			|	КОЛИЧЕСТВО(ТаблицаДанных." + ПолеСуммирования + ") КАК Количество
			|ИЗ
			|	" + ИмяМенеджераТаблицы + "." + ИмяТаблицы + " КАК ТаблицаДанных
			|";
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ВыводитьПустыеЗначения Тогда
		
		Если Лев(МетаМетка, 3) = "Рег" Тогда
			Если ПриводитьСтроковоеПоле Тогда
				ТекстЗапроса = ТекстЗапроса +
				"ИМЕЮЩИЕ
				|	КОЛИЧЕСТВО(ВЫРАЗИТЬ(ТаблицаДанных." + ПолеСуммирования + " КАК Строка(1))) > 0";
			Иначе
				ТекстЗапроса = ТекстЗапроса +
				"ИМЕЮЩИЕ
				|	КОЛИЧЕСТВО(ТаблицаДанных." + ПолеСуммирования + ") > 0";
			КонецЕсли;
		Иначе
			ТекстЗапроса = ТекстЗапроса +
			"ИМЕЮЩИЕ
			|	КОЛИЧЕСТВО(ТаблицаДанных.Ссылка) > 0";
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция СоздатьТаблицуРезультата(МетаМетка)
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Имя", тСтрока(150));
	Таблица.Колонки.Добавить("Синоним", тСтрока(150));
	Таблица.Колонки.Добавить("Количество", тЧисло(15));
	Таблица.Колонки.Добавить("ТабличныеЧасти");
	
	Если НЕ (Лев(МетаМетка, 3) = "Рег") Тогда
		Таблица.Колонки.Добавить("Помеченных", тЧисло(15));
		Таблица.Колонки.Добавить("СтрокТЧ", тЧисло(15));
		Таблица.Колонки.Добавить("СтрокТЧНаОбъект", тЧисло(15, 1));
		Таблица.Колонки.Добавить("Пузатость", тЧисло(15));
	КонецЕсли;
	
	Если МетаМетка = "Спр" ИЛИ МетаМетка = "ПВХ" Тогда
		Таблица.Колонки.Добавить("Групп", тЧисло(15));
		Таблица.Колонки.Добавить("Иерархический", Новый ОписаниеТипов("Булево"));
	ИначеЕсли МетаМетка = "Док" Тогда
		Таблица.Колонки.Добавить("Проведенных", тЧисло(15));
	КонецЕсли;
	
	Возврат Таблица;
	
КонецФункции

Функция ЗаполнитьСведенияОТабличныхЧастях(ОбъектМетаданных, МетаМетка, КоличествоОбъектов)
	
	Если Лев(МетаМетка, 3) = "Рег" ИЛИ НеВыводитьИнформациюОТабличныхЧастях Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	МетаТабличныхЧастей = ОбъектМетаданных.ТабличныеЧасти;
	Если МетаТабличныхЧастей.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТаблицаТЧ = Новый ТаблицаЗначений;
	ТаблицаТЧ.Колонки.Добавить("Имя", тСтрока(150));
	ТаблицаТЧ.Колонки.Добавить("Синоним", тСтрока(150));
	ТаблицаТЧ.Колонки.Добавить("Количество", тЧисло(15));
	ТаблицаТЧ.Колонки.Добавить("СтрокНаОбъект", тЧисло(15, 1));
	Запрос = Новый Запрос;
	Имя = ОбъектМетаданных.Имя;
	ИмяТаблицы = ПолучитьИмяТаблицыЗапросаПоМетаметке(МетаМетка);
	
	Для Каждого МетаТабЧасть Из МетаТабличныхЧастей Цикл
		
		ИмяТЧ = МетаТабЧасть.Имя;
		СинонимТЧ = МетаТабЧасть.Синоним;
		Количество = 0;
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(ТаблицаДанных.Ссылка) КАК Количество
		|ИЗ
		|	" + ИмяТаблицы + "." + Имя + "." + ИмяТЧ + " КАК ТаблицаДанных
		|";
		
		Если НЕ ВыводитьПустыеЗначения Тогда
			ТекстЗапроса = ТекстЗапроса +
			"ИМЕЮЩИЕ
			|	КОЛИЧЕСТВО(ТаблицаДанных.Ссылка) > 0";
		КонецЕсли;
		
		Запрос.Текст = ТекстЗапроса;
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Количество = Выборка.Количество;
		Иначе
			Продолжить;
		КонецЕсли;
		
		НоваяСтока = ТаблицаТЧ.Добавить();
		НоваяСтока.Имя = ИмяТЧ;
		НоваяСтока.Синоним = СинонимТЧ;
		НоваяСтока.Количество = Количество;
		НоваяСтока.СтрокНаОбъект = ?(КоличествоОбъектов = 0, 0, Количество / КоличествоОбъектов);
		
	КонецЦикла;
	
	Возврат ТаблицаТЧ;
	
КонецФункции

// для отчета по периодам

Функция ТекстЗапросаПоМетаданномуПоПериодам(МетаМетка, ИмяТаблицы)
	
	ИмяМенеджераТаблицы = ПолучитьИмяТаблицыЗапросаПоМетаметке(МетаМетка);
	ТекстДопУсловия = "";
	
	Если МетаМетка = "Док" ИЛИ МетаМетка = "БП" ИЛИ МетаМетка = "Зад" Тогда
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	МИНИМУМ(ЕстьNull(ВложенныйЗапрос.Количество, 0)) КАК Минимум,
		|	МАКСИМУМ(ЕстьNull(ВложенныйЗапрос.Количество, 0)) КАК Максимум,
		|	СРЕДНЕЕ(ЕстьNull(ВложенныйЗапрос.Количество, 0)) КАК Среднее,
		|	СУММА(ЕстьNull(ВложенныйЗапрос.Количество, 0)) КАК Количество
		|ИЗ
		|	(ВЫБРАТЬ
		|		НАЧАЛОПЕРИОДА(ТаблицаДанных.Дата, " + Периодичность + ") КАК Период,
		|		КОЛИЧЕСТВО(ТаблицаДанных.Ссылка) КАК Количество
		|	ИЗ
		|		" + ИмяМенеджераТаблицы + "." + ИмяТаблицы + " КАК ТаблицаДанных
		|	ГДЕ
		|		ТаблицаДанных.Дата МЕЖДУ &НачПериода И &КонПериода
		|	
		|	СГРУППИРОВАТЬ ПО
		|		НАЧАЛОПЕРИОДА(ТаблицаДанных.Дата, " + Периодичность + ")
		|	//ДопУсловие
		|) КАК ВложенныйЗапрос";
		
		ТекстДопУсловия = "ИМЕЮЩИЕ КОЛИЧЕСТВО(ТаблицаДанных.Ссылка) > 0";
		
	ИначеЕсли Лев(МетаМетка, 3) = "Рег" Тогда
		
		Если МетаМетка = "РегР" Тогда
			
			ТекстЗапроса = 
			"ВЫБРАТЬ
			|	МИНИМУМ(ЕстьNull(ВложенныйЗапрос.Количество, 0)) КАК Минимум,
			|	МАКСИМУМ(ЕстьNull(ВложенныйЗапрос.Количество, 0)) КАК Максимум,
			|	СРЕДНЕЕ(ЕстьNull(ВложенныйЗапрос.Количество, 0)) КАК Среднее,
			|	СУММА(ЕстьNull(ВложенныйЗапрос.Количество, 0)) КАК Количество
			|ИЗ
			|	(ВЫБРАТЬ
			|		НАЧАЛОПЕРИОДА(ТаблицаДанных.ПериодРегистрации, " + Периодичность + ") КАК Период,
			|		КОЛИЧЕСТВО(ТаблицаДанных.ПериодРегистрации) КАК Количество
			|	ИЗ
			|		" + ИмяМенеджераТаблицы + "." + ИмяТаблицы + " КАК ТаблицаДанных
			|	ГДЕ
			|		ТаблицаДанных.ПериодРегистрации МЕЖДУ &НачПериода И &КонПериода
			|	
			|	СГРУППИРОВАТЬ ПО
			|		НАЧАЛОПЕРИОДА(ТаблицаДанных.ПериодРегистрации, " + Периодичность + ")
			|	//ДопУсловие
			|) КАК ВложенныйЗапрос";
			
			ТекстДопУсловия = "ИМЕЮЩИЕ КОЛИЧЕСТВО(ТаблицаДанных.ПериодРегистрации) > 0";
			
		Иначе
			
			ТекстЗапроса = 
			"ВЫБРАТЬ
			|	МИНИМУМ(ЕстьNull(ВложенныйЗапрос.Количество, 0)) КАК Минимум,
			|	МАКСИМУМ(ЕстьNull(ВложенныйЗапрос.Количество, 0)) КАК Максимум,
			|	СРЕДНЕЕ(ЕстьNull(ВложенныйЗапрос.Количество, 0)) КАК Среднее,
			|	СУММА(ЕстьNull(ВложенныйЗапрос.Количество, 0)) КАК Количество
			|ИЗ
			|	(ВЫБРАТЬ
			|		НАЧАЛОПЕРИОДА(ТаблицаДанных.Период, " + Периодичность + ") КАК Период,
			|		КОЛИЧЕСТВО(ТаблицаДанных.Период) КАК Количество
			|	ИЗ
			|		" + ИмяМенеджераТаблицы + "." + ИмяТаблицы + " КАК ТаблицаДанных
			|	ГДЕ
			|		ТаблицаДанных.Период МЕЖДУ &НачПериода И &КонПериода
			|	
			|	СГРУППИРОВАТЬ ПО
			|		НАЧАЛОПЕРИОДА(ТаблицаДанных.Период, " + Периодичность + ")
			|	//ДопУсловие
			|) КАК ВложенныйЗапрос";
			
			ТекстДопУсловия = "ИМЕЮЩИЕ КОЛИЧЕСТВО(ТаблицаДанных.Период) > 0";
			
		КонецЕсли;
		
	Конецесли;
	
	//Если НЕ ВыводитьПустыеЗначения Тогда
	//	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//ДопУсловие", ТекстДопУсловия);
	//КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция СоздатьТаблицуРезультатаПоПериодам()
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Имя", тСтрока(150));
	Таблица.Колонки.Добавить("Синоним", тСтрока(150));
	Таблица.Колонки.Добавить("Количество", тЧисло(15));
	Таблица.Колонки.Добавить("Минимум", тЧисло(15));
	Таблица.Колонки.Добавить("Среднее", тЧисло(15, 1));
	Таблица.Колонки.Добавить("Максимум", тЧисло(15));
	
	Возврат Таблица;
	
КонецФункции

// для отчета по структуре и объему

Функция ПолучитьОбъемТаблицыСУБД(ИмяТаблицы, РасчетОбъема)
	
	Если НЕ РасчетОбъема Тогда
		Возврат 0;
	КонецЕсли;
	
	//???
	
	Возврат 0;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Текст подзаголовка для вывода в отчет
Функция ПолучитьПодзаголовокПоМетаметке(МетаМетка)
	
	Если МетаМетка = "Спр" Тогда
		Возврат "Справочники";
	ИначеЕсли МетаМетка = "Док" Тогда
		Возврат "Документы";
	ИначеЕсли МетаМетка = "ПВХ" Тогда
		Возврат "Планы видов характеристик";
	ИначеЕсли МетаМетка = "ПС" Тогда
		Возврат "Планы счетов";
	ИначеЕсли МетаМетка = "ПВР" Тогда
		Возврат "Планы видов расчета";
	ИначеЕсли МетаМетка = "БП" Тогда
		Возврат "Бизнес-процессы";
	ИначеЕсли МетаМетка = "Зад" Тогда
		Возврат "Задачи";
	ИначеЕсли МетаМетка = "РегС" И ВидОтчета = "ПоПериодам" Тогда
		Возврат "Периодические регистры сведений";
	ИначеЕсли МетаМетка = "РегС" Тогда
		Возврат "Регистры сведений";
	ИначеЕсли МетаМетка = "РегН" Тогда
		Возврат "Регистры накопления";
	ИначеЕсли МетаМетка = "РегБ" Тогда
		Возврат "Регистры бухгалтерии";
	ИначеЕсли МетаМетка = "РегР" Тогда
		Возврат "Регистры расчета";
	ИначеЕсли МетаМетка = "ПО" Тогда
		Возврат "Планы обмена";
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

// Текст подзаголовка шапки таблицы подраздела отчета
Функция ПолучитьПодзаголовокШапкиПоМетаметке(МетаМетка)
	
	Если МетаМетка = "Спр" Тогда
		Возврат "справочника";
	ИначеЕсли МетаМетка = "Док" Тогда
		Возврат "документа";
	ИначеЕсли МетаМетка = "ПВХ" Тогда
		Возврат "плана видов характеристик";
	ИначеЕсли МетаМетка = "ПС" Тогда
		Возврат "плана счетов";
	ИначеЕсли МетаМетка = "ПВР" Тогда
		Возврат "плана видов расчета";
	ИначеЕсли МетаМетка = "БП" Тогда
		Возврат "бизнес-процесса";
	ИначеЕсли МетаМетка = "Зад" Тогда
		Возврат "задачи";
	ИначеЕсли МетаМетка = "РегС" Тогда
		Возврат "регистра сведений";
	ИначеЕсли МетаМетка = "РегН" Тогда
		Возврат "регистра накопления";
	ИначеЕсли МетаМетка = "РегБ" Тогда
		Возврат "регистра бухгалтерии";
	ИначеЕсли МетаМетка = "РегР" Тогда
		Возврат "регистра расчета";
	ИначеЕсли МетаМетка = "ПО" Тогда
		Возврат "плана обмена";
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

Функция ПолучитьТипМетаданныхПоМетаметке(МетаМетка)
	
	Если МетаМетка = "Спр" Тогда
		Возврат "Справочники";
	ИначеЕсли МетаМетка = "Док" Тогда
		Возврат "Документы";
	ИначеЕсли МетаМетка = "ПВХ" Тогда
		Возврат "ПланыВидовХарактеристик";
	ИначеЕсли МетаМетка = "ПС" Тогда
		Возврат "ПланыСчетов";
	ИначеЕсли МетаМетка = "ПВР" Тогда
		Возврат "ПланыВидовРасчета";
	ИначеЕсли МетаМетка = "БП" Тогда
		Возврат "БизнесПроцессы";
	ИначеЕсли МетаМетка = "Зад" Тогда
		Возврат "Задачи";
	ИначеЕсли МетаМетка = "РегС" Тогда
		Возврат "РегистрыСведений";
	ИначеЕсли МетаМетка = "РегН" Тогда
		Возврат "РегистрыНакопления";
	ИначеЕсли МетаМетка = "РегБ" Тогда
		Возврат "РегистрыБухгалтерии";
	ИначеЕсли МетаМетка = "РегР" Тогда
		Возврат "РегистрыРасчета";
	ИначеЕсли МетаМетка = "ПО" Тогда
		Возврат "ПланыОбмена";
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

Функция ПолучитьИмяТаблицыЗапросаПоМетаметке(МетаМетка)
	
	Если МетаМетка = "Спр" Тогда
		Возврат "Справочник";
	ИначеЕсли МетаМетка = "Док" Тогда
		Возврат "Документ";
	ИначеЕсли МетаМетка = "ПВХ" Тогда
		Возврат "ПланВидовХарактеристик";
	ИначеЕсли МетаМетка = "ПС" Тогда
		Возврат "ПланСчетов";
	ИначеЕсли МетаМетка = "ПВР" Тогда
		Возврат "ПланВидовРасчета";
	ИначеЕсли МетаМетка = "БП" Тогда
		Возврат "БизнесПроцесс";
	ИначеЕсли МетаМетка = "Зад" Тогда
		Возврат "Задача";
	ИначеЕсли МетаМетка = "РегС" Тогда
		Возврат "РегистрСведений";
	ИначеЕсли МетаМетка = "РегН" Тогда
		Возврат "РегистрНакопления";
	ИначеЕсли МетаМетка = "РегБ" Тогда
		Возврат "РегистрБухгалтерии";
	ИначеЕсли МетаМетка = "РегР" Тогда
		Возврат "РегистрРасчета";
	ИначеЕсли МетаМетка = "ПО" Тогда
		Возврат "ПланОбмена";
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

Функция ПолучитьПоляСортировки()
	
	ПоляСорт = ПолеСортировки;
	
	Если ПолеСортировки = "КоличествоУбыв" Тогда
		ПоляСорт = "Количество убыв";
	КонецЕсли;
	
	Возврат ПоляСорт;
	
КонецФункции

Функция СформироватьИмяОбъекта(пИмя, пСиноним)
	
	Если пИмя = пСиноним Тогда
		Возврат пИмя;
	КонецЕсли;
	
	Возврат "" + пСиноним + " (" + пИмя + ")"
	
КонецФункции

Функция тСтрока(пДлина)
	
	Возврат Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(пДлина, ДопустимаяДлина.Переменная));
	
КонецФункции

Функция тЧисло(пДлина, пТочность = 0)
	
	Возврат Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(пДлина, пТочность, ДопустимыйЗнак.Любой));
	
КонецФункции

Функция ЭтоКлиентСервернаяБаза() Экспорт
	
	СтрокаСоединения = СтрокаСоединенияИнформационнойБазы();
	
	Возврат Найти(НРег(СтрокаСоединения), "file") = 0;
	
КонецФункции
