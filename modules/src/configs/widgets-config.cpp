#include <FL/Fl.H>
#include <FL/Fl_Box.H>
#include <FL/Fl_Radio_Button.H>
#include <FL/Fl_Radio_Light_Button.H>
#include <FL/Fl_Radio_Round_Button.H>
#include <FL/Fl_Window.H>
#include <FL/fl_draw.H>
#include <pwd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>

void load_fonts();
Fl_Font roboto = FL_HELVETICA;
Fl_Font fa = FL_HELVETICA;

class RadioButtonStyled : public Fl_Radio_Button {
   public:
    RadioButtonStyled(int x, int y, int w, int h, const char* label,
                      const char* icon = 0, unsigned int flag_value = 0)
        : Fl_Radio_Button(x, y, w, h, label) {
        box(FL_FLAT_BOX);
        color(0x222222ff);
        selection_color(0x4d8ddbff);
        labelsize(14);
        this->icon = icon;
        this->flag_value = flag_value;
    }

    const char* icon = 0;
    unsigned int flag_value;

    int handle(int event) override {
        switch (event) {
            case FL_ENTER:
                color(0x333333ff);
                redraw();
                return 1;

            case FL_LEAVE:
                color(0x222222ff);
                redraw();
                return 1;

                // case FL_PUSH:
                //     if (!visible()) show();
                //     return 1;
        }
        return Fl_Radio_Button::handle(event);
    }

    void draw() override {
        fl_draw_box(box(), x(), y(), w(), h(),
                    value() ? selection_color() : color());

        fl_color(value() ? fl_rgb_color(0, 168, 255) : FL_GRAY);

        fl_color(FL_WHITE);
        fl_font(fa, labelsize());
        fl_draw(icon, x() + h() * .1, y() + h() * .1, h() * .8, h() * .8,
                FL_ALIGN_CENTER);

        if (label() && label()[0]) {
            fl_font(roboto, labelsize());
            fl_color(FL_WHITE);
            fl_draw(label(), x() + h(), y() + labelsize() / 4, w(), 20,
                    FL_ALIGN_LEFT);
        }
    }
};

class BoxStyled : public Fl_Box {
   public:
    BoxStyled(int x, int y, int w, int h, const char* text)
        : Fl_Box(x, y, w, h, text) {
        box(FL_FLAT_BOX);
        color(0x222222ff);
        labelsize(14);
    }

    void draw() override {
        fl_draw_box(box(), x(), y(), w(), h(), color());

        if (label() && label()[0]) {
            fl_font(roboto, labelsize());
            fl_color(0xdbc14dff);
            fl_draw(label(), x() - 8, y(), w(), h(), FL_ALIGN_CENTER);
        }
    }
};

class WindowAutoClose : public Fl_Window {
   public:
    WindowAutoClose(int w, int h, const char* t = 0) : Fl_Window(w, h, t) {
        color(0x222222ff);
        border(false);
    }

    int handle(int event) override {
        switch (event) {
                // case FL_ENTER:
                //     show();
                //     return 1;

            case FL_LEAVE:
                hide();
                return 1;

                // case FL_PUSH:
                //     if (!visible()) show();
                //     return 1;
        }
        return Fl_Window::handle(event);
    }

    void show() override{
        int mouse_x, mouse_y;
        Fl::get_mouse(mouse_x, mouse_y);
        y(mouse_y-16);

        if (y() < Fl::h() * 0.022) {
            y(Fl::h() * 0.022);
        } else if ((y()+h()) > Fl::h() * (1.0 - 0.022)) {
            y(Fl::h() * (1.0 - 0.022) - h()+1);
        }

        int win_x = mouse_x - (w()/2);
        if(win_x < 0) win_x = 0;
        else if((win_x + w()) > Fl::w()) win_x = Fl::w()-w();

        x(mouse_x - w() / 2);
        Fl_Window::show();
    }
};

void load_fonts() {
    // Força o FLTK a carregar todas as fontes do sistema (Roboto + Font
    // Awesome)
    Fl::set_fonts("-*");  // "-" = todas as fontes disponíveis

    for (int i = 0; i < Fl::set_fonts(0); i++) {
        const char* name = Fl::get_font_name((Fl_Font)i);

        if (name && strstr(name, "Roboto Bold")) {
            roboto = (Fl_Font)i;
            // printf("Roboto encontrada: %s (id=%d)\n", name, i);
            break;
        }
    }

    for (int i = 0; i < Fl::set_fonts(0); i++) {
        const char* name = Fl::get_font_name((Fl_Font)i);
        if (name &&
            (strstr(name, "Font Awesome") || strstr(name, "FontAwesome"))) {
            fa = (Fl_Font)i;
            // printf("Font Awesome encontrada: %s (id=%d)\n", name, i);
            break;
        }
    }

    if (roboto == FL_HELVETICA) printf("Roboto not found.\n");
    if (fa == FL_HELVETICA) printf("Font Awesome not found.\n");
}