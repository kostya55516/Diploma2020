\ProvidesClass{spbau-diploma}[2015/05/22 SPbAU LaTeX diploma class]
\def\my@fontsize{12pt}\def\my@baseclass{article}\def\my@title12pt{}\def\my@body14pt{}

% Если используется опция 14pt то нужно несколько хаков
\DeclareOption{14pt}{
  \def\ignore#1{}
  % во-первых, класс наследуется от extarticle
  \def\my@fontsize{14pt}
  \def\my@baseclass{extarticle}
  
  % во-вторых, титульный лист должен набираться так, как будто
  % используется шрифт 12pt - иначе он выглядит совсем конским
  % Для этого мы явно загружаем size12.clo, но так как он на такое не рассчитан,
  % и использует \newcommand для определения всяких \small и \Large
  % то у нас \newcommand временно превращается в \renewcommand
  \let\orignewcommand\newcommand
  \let\origNeedsTeXFormat\NeedsTeXFormat
  \def\my@title12pt{
    \let\newcommand\renewcommand
    \makeatletter
    \input{size12.clo}%
    \makeatother  
    \let\newcommand\orignewcommand
  }
  % в-третьих, после того как титульный лист сгенерирован, нужно снова вернуться
  % к базовому шрифту 14pt. Применяется такой же хак: загрузи size14.clo 
  % временно переопределив \newcommand => \renewcommand
  \def\my@body14pt{
    % отдельное внимание подавлению команды \NeedsTeXFormat, которая требует
    % чтобы код size14.clo выполнялся в преамбуле (а тут он уже внутри документа)
    \let\NeedsTeXFormat\ignore
    \let\newcommand\renewcommand
    \makeatletter
    \input{size14.clo}%
    \makeatother  
    \let\newcommand\orignewcommand
    \let\NeedsTeXFormat\origNeedsTeXFormat
  }
}
\ProcessOptions\relax
\LoadClass[a4paper,\my@fontsize]{\my@baseclass}

\usepackage{fontspec}
\setmainfont[Mapping=tex-text]{CMU Serif}
\setsansfont{CMU Sans Serif}               
\setmonofont{CMU Typewriter Text}

% Поля настраиваются командами \newgeometry во время и после генерации титульных 
% страниц и 
\usepackage[a4paper]{geometry}

\usepackage{fancyhdr}
\usepackage{ifthen}
%% Мы используем компилятор XeLaTex, который дружит с Unicode и True Type/Open Type
%% шрифтами. Для русификации достаточно подключить пакет fontspec и
%% выбрать Unicode шрифт в котором есть кириллические глифы. Ниже
%% основным шрифтом выбирается Unicode версия шрифта Computer Modern с заcечками
\usepackage{fontspec}
\setmainfont[Mapping=tex-text]{CMU Serif}

%% В XeLaTex заменой известного пакета babel является пакет polyglossia.
%% Теперь у нас будут переносы слов
\usepackage{polyglossia}
\setdefaultlanguage{russian}


%% Отступ в первом абзаце
\usepackage{indentfirst}
%% Гиперссылки
\usepackage[colorlinks=true,urlcolor=black,linkcolor=black,filecolor=black,citecolor=black]{hyperref}

%% Включение графических файлов
%% we don't need to load graphicx since it will be loaded by xunicode (which is loaded by fontspec) 
\usepackage[titletoc]{appendix}

%% Эта команда добавляет отчеркнутое место для подписи после имени
%% Аргументы: имя и пояснение под чертой (например, слово "подпись")
\def\sigspace{\\[3em]}
\newcommand\sigplace[2]{
#1\\[1.2em]
\underline{\hspace{3cm}}\\[-0.2em]
{\footnotesize #2}
\def\sigspace{\\[1em]%
\def\sigspace{\\[3em]}}
}

%% Параметры заполнения титульного листа
\usepackage{xkeyval}

%% Русскоязычный вариант
\define@key[ru]{mytitle}{university}{\def\my@title@university@ru{#1}}
\define@key[ru]{mytitle}{faculty}{\def\my@title@faculty@ru{#1}}
\define@key[ru]{mytitle}{chair}{\def\my@title@chair@ru{#1}}
\define@key[ru]{mytitle}{title}{\def\my@title@title@ru{#1}}
\define@key[ru]{mytitle}{position}{\def\my@title@position@ru{#1}}
\define@key[ru]{mytitle}{group}{\def\my@title@group@ru{#1}}
\define@key[ru]{mytitle}{author}{\def\my@title@author@ru{#1}}
\define@key[ru]{mytitle}{supervisor}{\def\my@title@supervisor@ru{#1}}
\define@key[ru]{mytitle}{supervisorPosition}{\def\my@title@supervisorPosition@ru{#1}}
\define@key[ru]{mytitle}{reviewer}{\def\my@title@reviewer@ru{#1}}
\define@key[ru]{mytitle}{reviewerPosition}{\def\my@title@reviewerPosition@ru{#1}}
\define@key[ru]{mytitle}{chairHead}{\def\my@title@chairHead@ru{#1}}
\define@key[ru]{mytitle}{chairHeadPosition}{\def\my@title@chairHeadPosition@ru{#1}}
\define@key[ru]{mytitle}{year}{\def\my@title@year@ru{#1}}
\define@key[ru]{mytitle}{city}{\def\my@title@city@ru{#1}}
\define@choicekey*[ru]{mytitle}{type}{diploma,coursework,master,bachelor}{\def\my@title@type@ru{#1}}

\newcommand\filltitle[2]{
%% Значения по умолчанию для обоих языков
    \ifthenelse{\equal{#1}{ru}}
        {
        \presetkeys[#1]{mytitle}{
          university = {Федеральное государственное автономное образовательное учреждение\\высшего образования\\«Национальный исследвательский университет «Высшая школа экономики»\\Факультет Санкт-Петербургская школа физико-математических и компьютерных наук\\Депортамент информатики\\Основная профессиональная образовательная программа\\«Прикладная математика и информатика»},
          faculty = {Центр высшего образования},
          city = {Санкт-Петербург},
          year = {\the\year},
          type = {diploma}
        }{}
        }
        {}
    \setkeys[#1]{mytitle}{#2}
}

%% Титульная страница на русском языке
\newcommand\maketitleru{
\fancypagestyle{titleru}{
    \fancyhf{}  % clear all header and footer fields
    \renewcommand{\headrulewidth}{0pt}  % remove head ruler
    %% В верхнем колонтитуле будет университет и кафедра
    \chead{\large \my@title@university@ru \\ \my@title@faculty@ru \\ \vskip 1em{\large \my@title@chair@ru \\}}
    %% В нижнем колонтитуле город и год
    \cfoot{\large\parbox[b]{\textwidth}{\centering \my@title@city@ru\\ \my@title@year@ru}}
}

\title{\my@title@title@ru}
\begin{titlepage}
\newgeometry{top=20mm,bottom=20mm,left=20mm,right=15mm,nohead,includeheadfoot}
\thispagestyle{titleru}
\begin{center}
    \vspace*{0.25\textheight}
    {\Large\my@title@author@ru}
    
    \vskip 2em
    {\Huge \@title\\}
    
    \vskip 1em
    {\large 
    \ifthenelse{\equal{\my@title@type@ru}{coursework}}
    {Курсовая работа}
    {\ifthenelse{\equal{\my@title@type@ru}{diploma}}
    {Дипломная работа}
    {\ifthenelse{\equal{\my@title@type@ru}{master}}
    {Магистерская диссертация}
    {\ifthenelse{\equal{\my@title@type@ru}{bachelor}}
    {Бакалаврская работа}
    }}}
    \\}
    \vskip 2em
    \ifthenelse{\equal{\my@title@type@ru}{coursework}}
    {\normalsize \raggedleft 
    Научный руководитель:\\
    \my@title@supervisorPosition@ru\ \my@title@supervisor@ru
    }
    {\normalsize \raggedleft 
    Допущена к защите.\\
    Зав. кафедрой:\\
    \my@title@chairHeadPosition@ru\ \my@title@chairHead@ru\sigspace
    Научный руководитель:\\
    \my@title@supervisorPosition@ru\ \my@title@supervisor@ru\sigspace
    Рецензент:\\
    \my@title@reviewerPosition@ru\ \my@title@reviewer@ru
    }
\end{center}
\end{titlepage}
}

%% Титульный лист генерируется, если для соответствующего языка
%% определен аргумент title
%% Счетчик страниц автоматически увеличивается при генерации титульнго листа
\renewcommand\maketitle{
%% На титульной странице все кроме полей соответствует \documentclass[12pt]{article}
\my@title12pt

\newcounter{titlepages}
\setcounter{titlepages}{1}
\begin{spacing}{1.0}
\ifthenelse{\isundefined{\my@title@title@ru}}{}{
  % fancyhdr set height of the top/bottom headers automatically
  % so set them to zero to be sure that he does it 
  \setlength{\headheight}{0pt}
  \setlength{\footskip}{0pt}
  \maketitleru\addtocounter{titlepages}{1}
}
\end{spacing}
\setcounter{page}{\value{titlepages}}
% restore preamble's geometry
\my@body14pt
\newgeometry{a4paper,top=20mm,bottom=20mm,left=30mm,right=15mm,nohead,includeheadfoot}
}

\newcounter{secionnumber}
\setcounter{secionnumber}{0}

%% Каждая глава начинается с новой страницы, введение и заключение не
%% нумеруются, но в оглавление входят. А само оглавление в оглавление не входит
\let\safeoldsection\section
\let\old@section\section
\def\section{\@ifstar\@section\@@section}
\def\@section#1{\setcounter{figure}{0}%
                \setcounter{table}{0}%
                \addtocounter{secionnumber}{1}\newpage\old@section*{#1}%
        \ifthenelse{\equal{#1}{\contentsname}}%
           {}%
           {\addcontentsline{toc}{section}{#1}}%
}
\def\@@section#1{\newpage\old@section{#1}}

%% Полуторный интервал
\usepackage[nodisplayskipstretch]{setspace}
\onehalfspacing

%% Переименование "содержания" в "оглавление"
\gappto\captionsrussian{\renewcommand{\contentsname}{Оглавление}}

\let\savenumberline\numberline
\def\numberline#1{\savenumberline{#1.}}


\def\figref#1{Рис.~\ref{fig:#1}}


\usepackage{amsmath}
\numberwithin{table}{section}
\numberwithin{figure}{section}

\def\myfig#1#2#3#4{
\begin{figure}[h]
    \centering
    \includegraphics[scale=#4]{figs/#1}
    \caption{#2}
    \label{fig:#3}
\end{figure}
}

\usepackage{xcolor}

\def\TODO#1{{\color{red}\textbf{TODO: #1}}}

\usepackage[perpage]{footmisc}

\usepackage{glossaries}
\usepackage{glossary-longragged}

\input{glossary.tex}

\makenoidxglossaries

\def\cpp{C\texttt{++} }

\usepackage{tocloft}
\renewcommand{\cftbeforesecskip}{7pt}

