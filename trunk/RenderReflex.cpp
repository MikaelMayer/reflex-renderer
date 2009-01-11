/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Name: RenderReflex.cpp
 * Author: Mika�l Mayer
 * Work started: 20080614
 * Purpose:  Render a reflex given some arguments.
 * Format: Ini file.
formula="The(very+complicated*formula)which/will-give(some)*nice*reflex"
width=1600
height=1600
winmin=-4-4i
winmax=4+4i
output=c:\the\path\where\to\store\the\file.bmp
 * An AutoIt3 script calls the program with a nice interface
 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#include <iostream>
#include <fstream>
#include <string>
#include <algorithm>
#include <argstream.h>
//#include "tbb/task_scheduler_init.h"
//#include "tbb/parallel_for.h"
#//include "tbb/blocked_range.h"
#include "stdafx.h"
#include "complexlib/complex.h"
#include "complexlib/functions.h"
#include "complexlib/lexeur.h"

#define MAX_FUNC_LENGTH 0xFFFF
//using namespace tbb;
using namespace std;
static const size_t N = 6;

/*class SubStringFinder {
  const string str;
  size_t *max_array;
  size_t *pos_array;
  public:
  void operator() ( const blocked_range<size_t>& r ) const {
    for ( size_t I = r.begin(); I != r.end(); ++I ) {
      size_t max_size = 0, max_pos = 0;
      for (size_t j = 0; j < str.size(); ++j)
        if (j != I) {
          size_t limit = str.size()-max(I,j);
          for (size_t k = 0; k < limit; ++k) {
            if (str[I + k] != str[j + k]) break;
            if (k > max_size) {
              max_size = k;
              max_pos = j;
            }
          }
        }
        max_array[I] = max_size;
        pos_array[I] = max_pos;
    }
  }
  SubStringFinder(string &s, size_t *m, size_t *p) : str(s), max_array(m), pos_array(p) { }
};*/

void putInvertedNumber(ofstream &file, int size, int number) {
  char a;
  while (size>0) {
    a = number&0xFF;
    file.write(&a, 1);
    number >>= 8;
    size--;
  }
}

Function* getFunction(const char* string, const char* name) {
  Parseur *parseur = new Parseur(string);
  Function *function = parseur->valeurFonction();
  if(!function) {
    cerr << name << " error : " << string << " <= "
      << Parseur::errorNum[parseur->errorCode()]
      << " at position " << parseur->getPosition() << endl;
    cerr << name << " error : ";
    for(int i = 0; i< parseur->getPosition(); i++) {
      cerr << " ";
    }
    cerr << "^" << endl;
  } else {
    if(parseur->hasBeenMacro()) {//On recopie la fonction...
      TCHAR funcString[MAX_FUNC_LENGTH];
			*(function->toStringConst(funcString, funcString+MAX_FUNC_LENGTH))=L'\0';
      cout << "formula:" << funcString << endl;
		}
  }
  delete parseur;
  return function;
}

//Returns a boolean indicating if the operation was a success.
//Puts the integer from the string into value.
//Displays a pretty error message containing the name of the variable.
bool getInt(const char* string, const char* name, int& value) {
  Function *function = getFunction(string, name);
  if(function==NULL)
    return false;
  bool return_value = true;
  if(!function->isConstant()) {
    cerr << name << " error : " << string << " is not constant";
    return_value = false;
  } else {
    value = static_cast<int>((dynamic_cast<Constante*>(function))->valeur.real());
  }
  function = function->kill();
  return return_value;
}

bool getHex(const char* string, const char* name, unsigned int& value) {
  unsigned int result = 0;
  while(*string) {
    unsigned int c = *string - '0';
    if(! (c >= 0 && c <= 9) ) {
      c = *string - 'A' + 10;
      if(! (c >= 10 && c <= 15) ) {
        cerr << name << " error : " << string << " is not in hex format (got "
             << *string << ")" << endl;;
        return false;
      }
    }
    result = result * 16 + c;
    string++;
  }
  value = result;
  return true;
}

bool getCplx(const char* string, const char* name, cplx& value) {
  Function *function = getFunction(string, name);
  if(function==NULL)
    return false;
  bool return_value = true;
  if(!function->isConstant()) {
    cerr << name << " error : " << string << " is not constant";
    return_value = false;
  } else {
    value = (dynamic_cast<Constante*>(function))->valeur;
  }
  function = function->kill();
  return return_value;
}

void getMinXYMaxXY(cplx winmin, cplx winmax,
                   int x, int y,
                   double &min_x, double &min_y,
                   double &max_x, double &max_y) {
  double dx = winmax.real()-winmin.real();
  double dy = winmax.imag()-winmin.imag();

  min_x = winmin.real();
  min_y = winmin.imag();
  max_x = winmax.real();
  max_y = winmax.imag();
  double cen_x = (min_x + max_x)/2.;
  double cen_y = (min_y + max_y)/2.;

  //  Cut the observing tree if needed.
  double diffRatio = dx * y - dy * x;
  if (diffRatio != 0) {
    if (diffRatio < 0) {  // rendering is larger than the pre-display one.
      max_y = cen_y + (y * (max_x - cen_x)) / x;
      min_y = cen_y + (y * (min_x - cen_x)) / x;
    } else { // rendering is higher than the pre-display one.
      max_x = cen_x + (x * (max_y - cen_y)) / y;
      min_x = cen_x + (x * (min_y - cen_y)) / y;
    }
  }
}

int renderBmp(const char* formula_string, int width, int height,
              const char* winmin_string, const char* winmax_string, const char* output_string,
              int seed_init, unsigned int colornan, bool realmode
              ) {
  bool fine = true;
  int errpos = 0;
  cplx winmin, winmax;

  srand(seed_init);
  Function *f_formula = getFunction(formula_string, "Formula");

  fine = fine && f_formula;
  fine = fine && getCplx(winmin_string, "Winmin", winmin);
  fine = fine && getCplx(winmax_string, "Winmax", winmax);
  if(!fine) {
    if(f_formula)	f_formula = f_formula->kill();
    return -1;
  }
  cplx::color_NaN = colornan;

  ofstream output_file(output_string, ios::binary | ios::out);
  if(!output_file.is_open()) {
    if(f_formula)	f_formula = f_formula->kill();
    cerr << "Output file invalid : " << output_string << endl;
    return -1;
  }
  int x = width, y = height;
  int taille = 3*x*y;
  int offset = x % 4;
  putInvertedNumber(output_file, 1, 66);                      //  B
  putInvertedNumber(output_file, 1, 77);                      //  M
  putInvertedNumber(output_file, 8, (taille+(y*offset)+54));  //  Total size
  putInvertedNumber(output_file, 4, 54);                      //  Head total size.
  putInvertedNumber(output_file, 4, 40);                      //  Head size from here.
  putInvertedNumber(output_file, 4, x);                       //  width
  putInvertedNumber(output_file, 4, y);                       //  height
  putInvertedNumber(output_file, 2, 1);                       //  number of layers
  putInvertedNumber(output_file, 6, 24);                      //  number of colors
  putInvertedNumber(output_file, 20, (taille+y*offset));      //  bitmap size.
  
  double min_x, min_y, max_x, max_y;
  getMinXYMaxXY(winmin, winmax, x, y,
                min_x, min_y, max_x, max_y);

  double iMult = (max_x - min_x) / (x - 1);
  double iBase = min_x;
  double jMult = (max_y - min_y) / (y - 1);
  double jBase = min_y;
  
  if(realmode == 0) {
    for (int j = 0; j < y; j++) {
      cout << j << "/" << y << endl;
      for (int i = 0; i < x; i++) {
        COLORREF color = f_formula->eval(cplx(i*iMult+iBase, j*jMult+jBase)).couleur24();
        putInvertedNumber(output_file, 3, color);
      }
      putInvertedNumber(output_file, offset, 0);
    }
  } else {
    double d0 = 0;
    double d1 = 0;
    unsigned int color_base = 0, color = 0;
    double *valeurs = new double[x];
    double *valeursj = new double[x];
    double *coefdirs = new double[x - 1];
    for (int i = 0; i < x; i++) {
      valeurs[i] = f_formula->eval(cplx(i*iMult+iBase, 0)).real();
      valeursj[i] = (valeurs[i] - jBase)/jMult;
    }
    for (int i = 0; i < x-1; i++) {
      double tmp = (valeursj[i+1]-valeursj[i]);
      coefdirs[i] = 1.0/sqrt(1.0+tmp*tmp);
      coefdirs[i] *= tmp > 0 ? 1 : -1;
    }
    for (int j = 0; j < y; j++) {
      cout << j << "/" << y << endl;
      color_base = cplx(j * jMult + jBase, 0).couleur24();
      for (int i = 0; i < x; i++) {
        //Calcul de la distance du point � la courbe
        double dmin = 2.0;
        if((j > valeursj[i]+0.5 && (i == 0 || j > valeursj[i - 1] + 0.5)
                                && (i == x - 1 || j > valeursj[i + 1] + 0.5))
           || (j < valeursj[i]-0.5 && (i == 0 || j < valeursj[i - 1] - 0.5)
                                   && (i == x - 1 || j < valeursj[i + 1] - 0.5)))
        {
        } else {
          if (i > 0) {
            d0 = (valeursj[i] - j) * coefdirs[i-1];
          }
          if (i < x - 1) {
            d1 = (j - valeursj[i]) * coefdirs[i];
          } else {
            d1 = d0;
          }
          if (i == 0) d0 = d1;
          if(d0 <= 0 && d1 <= 0) {
            dmin = j > valeursj[i] ? j - valeursj[i] : valeursj[i] - j;
          } else if(d0 >= 0 && d1 >= 0) {
            if(d0 > d1) {
              dmin = d1;
            } else {
              dmin = d0;
            }
          } else {
            if(d0 > 0)
              dmin = d0;
            if(d1 > 0)
              dmin = d1;
          }
        }
        const double limup = 1.014;
        if(dmin <= 0.5) {          // Pile sur la ligne
          color = color_base;
        } else if(dmin >= limup) { // En dehors de la ligne
          color = 0xFFFFFF;
        } else {                   // Sur la limite de la ligne: d�grad�
          double coef = (dmin - 0.5)/(limup - 0.5);
          unsigned int blu = ((color_base & 0xFF0000) >> 16);
          unsigned int gre = ((color_base & 0x00FF00) >> 8);
          unsigned int red =  (color_base & 0x0000FF);
          red = (int)(255.0 * coef + (1.0 - coef) * red);
          gre = (int)(255.0 * coef + (1.0 - coef) * gre);
          blu = (int)(255.0 * coef + (1.0 - coef) * blu);
          color = RGB(red, gre, blu);
        }
        putInvertedNumber(output_file, 3, color);
      }
      putInvertedNumber(output_file, offset, 0);
    }
    delete []valeurs;
    delete []valeursj;
    delete []coefdirs;
  }
  output_file.close();
  f_formula = f_formula->kill();
  cout << "Done." << endl;
  return 0;
}

int calculateNewWindow(int width, int height, const char* winmin_string,
                   const char* winmax_string, int deltax, int deltay) {
  bool fine = true;
  int errpos = 0;
  cplx winmin, winmax;
  fine = fine && getCplx(winmin_string, "Winmin", winmin);
  fine = fine && getCplx(winmax_string, "Winmax", winmax);
  if(!fine) {
    return -1;
  }
  double min_x, min_y, max_x, max_y;

  getMinXYMaxXY(winmin, winmax, width, height,
                min_x, min_y, max_x, max_y);
  width -= 1;
  height -= 1;
  double move_real = (deltax * (max_x - min_x)) / width;
  double move_imag = (deltay * (max_y - min_y)) / height;
  cplx new_winmin(min_x + move_real, min_y + move_imag);
  cplx new_winmax(max_x + move_real, max_y + move_imag);
  char new_winmin_string[256];
  char new_winmax_string[256];
  new_winmin.toString(new_winmin_string);
  new_winmax.toString(new_winmax_string);
  cout << new_winmin_string << ";" << new_winmax_string << endl;
  return 0;
}

int simplify_formula(const char* formula_string, int seed_init, bool openoffice_formula) {
  bool fine = true;
  int errpos = 0;

  srand(seed_init);
  Function *f_formula = getFunction(formula_string, "Formula");
  fine = fine && f_formula;
  if(!fine) {
    if(f_formula)	f_formula = f_formula->kill();
    return -1;
  }
  int size_func = MAX_FUNC_LENGTH;
  TCHAR* funcStringEnd = 0;
  TCHAR* funcString = 0;
  while(true) {
    funcString = new TCHAR[size_func + 1];
    TCHAR* funcStringMax = funcString+size_func;

    funcStringEnd = f_formula->toStringConst(funcString, funcStringMax, openoffice_formula?OPENOFFICE3_TYPE: DEFAULT_TYPE);
    if(funcStringEnd == funcStringMax) {
      delete funcString;
      size_func *= 2;
      continue;
    }
    break;
  }
  if(funcStringEnd) *(funcStringEnd)=L'\0';
  if(funcString) cout << "formula:" << funcString << endl;
  else           cout << "Error ! unable to convert formula to string" << endl;
  if(f_formula)  f_formula = f_formula->kill();
  if(funcString) delete funcString;
  return 0;
}

inline void set_if_tag(const char* arg, const char* TAG, const char * &var) {
  size_t t = _tcslen(TAG);
  if(_strnicmp(arg, TAG, t)==0)
    var = arg+t;
}
inline void set_if_null(const char* &value, const char* DEFAULT) {
  if(value == NULL) {
    value = DEFAULT;
  }
}


/*void displayUsage() {
  cerr << "Usage:" << endl;
  cerr << "RenderReflex.exe render formula={formula} [options]" << endl;
  cerr << "  Renders the reflex to a BMP file." << endl;
  cerr << "  The options are:" << endl;
  cerr << "    width=[int]  The rendering with in pixels. Default : " << DEFAULT_WIDTH << endl;
  cerr << "    height=[int] The rendering height in pixels. Default : " << DEFAULT_HEIGHT << endl;
  cerr << "    winmin=[cplx]   The lower left complex. Default : " << DEFAULT_WINMIN << endl;
  cerr << "    winmax=[cplx]   The upper right complex. Default :" << DEFAULT_WINMAX << endl;
  cerr << "    output=[path]   The file where to render. Default : " << DEFAULT_OUTPUT << endl;
  cerr << "    colornan=[integer] The default NaN color. Default : " << DEFAULT_COLORNAN << endl;
  cerr << "    realmode=[bool] If it only renders the real part. Default : " << DEFAULT_REALMODE << endl;
  cerr << "RenderReflex.exe new_window [options]" << endl;
  cerr << "  Returns new window coordinates if the original window is shifted." << endl;
  cerr << "  The options are width, height, winmin, winmax, and : "<< endl;
  cerr << "    delta_x=[int] The horizontal shift. Default : 0"<< endl;
  cerr << "    delta_y=[int] The vertical shift. Default : 0"<< endl;
  cerr << "RenderReflex.exe simplify formula={formula} [seed={integer}]" << endl;
  cerr << "  Simplifies an expression/function. Like a calculator." << endl;
}*/


int main(int argc, char** argv) {
  
  argstream as(argc, argv);

  bool render_mode;
  bool new_window;
  bool simplify_mode;
  as >> option("render", render_mode,
    "Renders the reflex to a BMP file.\n"
    "Used options are --width, --height, --winmin, --winmax, --output, --colornan, --realmode, --seed");
  as >> option("new_window", new_window,
    "Returns new window coordinates if the original window is shifted.\n"
    "Used options are --width, --height, --winmin, --winmax, --delta_x, --delta_y.");
  as >> option("simplify", simplify_mode,
    "Simplifies an expression/function. Like a calculator.\n"
    "Used options are --formula, --seed");

  string formula_string= "0";
  int width = 201;
  int height = 201;
  string winmin_string = "-4-4i";
  string winmax_string = "4+4i";
  string output_string = "c:\\tmp.bmp";
  string deltax_string = "0";  int delta_x=0;
  string deltay_string = "0";  int delta_y=0;
  int seed   = 1;
  string colornan_string = "0xFFFFFF";
  unsigned int colornan = 0xFFFFFF;
  bool realmode;
  bool openoffice_formula;

  as >> parameter('f', "formula", formula_string, "A formula like (1+2-x)/sin(z)", false)
     >> parameter('w', "width", width, "The rendering width in pixels", false)
     >> parameter('h', "height", height, "The rendering height in pixels", false)
     >> parameter('m', "winmin", winmin_string, "The lower left complex of the reflex", false)
     >> parameter('n', "winmax", winmax_string, "The upper right complex of the reflex", false)
     >> parameter('o', "output", output_string, "The file where to render", false)
     >> parameter('s', "seed", seed, "The seed used by the functions randh and randf", false)
     >> parameter('c', "colornan", colornan, "The default NaN color in hex", false)
     >> option('r', "realmode", realmode, "If it only renders the real part")
     >> parameter('d', "delta_x", deltax_string, "The horizontal shift", false)
     >> parameter('e', "delta_y", deltay_string, "The vertical shift", false)
     >> option("openoffice", openoffice_formula, "If it outputs the formule using OpenOffice style")
     >> help();

  sscanf_s(deltax_string.c_str(), "%d", &delta_x);
  sscanf_s(deltay_string.c_str(), "%d", &delta_y);
  sscanf_s(colornan_string.c_str(), "%x", &colornan);
 // cout << "colornan = " << colornan << endl;
  if (as.helpRequested()) {
    cout<<as.usage()<<endl;
    exit(0);
  }
  if(!as.isOk()) {
    as.defaultErrorHandling();
    exit(1);
  }

  if(render_mode) {
    return renderBmp(formula_string.c_str(), width, height,
                     winmin_string.c_str(), winmax_string.c_str(), output_string.c_str(),
                     seed, colornan, realmode
                     );
  }
  if(simplify_mode) {
    return simplify_formula(formula_string.c_str(), seed, openoffice_formula);
  }
  if(new_window) {
    //cout << width << ", " << height << ", " << delta_x << ", " << delta_y << endl;
    return calculateNewWindow(width, height, winmin_string.c_str(),
                              winmax_string.c_str(), delta_x, delta_y);
  }
  
  /*
  task_scheduler_init init;
  string str[N] = { string("a"), string("b") };
  for (size_t i = 2; i < N; ++i) str[i] = str[i-1]+str[i-2];
  string &to_scan = str[N-1];

  cout << "String to scan:" << endl << to_scan << endl;

  size_t *max = new size_t[to_scan.size()];
  size_t *pos = new size_t[to_scan.size()];

  parallel_for(blocked_range<size_t>(0, to_scan.size()),
      SubStringFinder(to_scan, max, pos),
      auto_partitioner());

  for (size_t i = 0; i < to_scan.size(); ++i) {
    cout << " " << max[i] << "(" << pos[i] << ")";
    if (max[i] > 0) {
      cout << " matched on " << to_scan.substr(i, max[i]+1);
    }
    cout << endl;
  }*/
  //system("pause");
  return 0;
}