#pragma mpwc_relax on

extern int func_0027ECA0(void*, int, int, int);
extern int func_0027E7A0(void*, byte, int, int);
extern int func_0027E510(void*, byte, int, int);

static inline s32 func_00243B58(text_window* arg0, text_window_190* arg1, byte* arg2) {
    if (func_00274700(arg0, arg1, arg2, 0x1) != 0x1) {
        return false;
    }

    if (func_00274700(arg0, arg1, arg2, 0x2) == -0x1) {
        return false;
    }

    return true;
}

static inline s32 func_00243760(text_window* arg0, text_window_190* arg1, byte* arg2) {
    if (func_002748C0(arg0, arg1, arg2, 0x1) != 0x0) {
        if (func_002748C0(arg0, arg1, arg2, 0x2) != 0x0) {
            *(undefined4*)&arg1->field272_0x194 = 0x0;
            arg1->field276_0x198 = 0x0;
            return false;
        }
        return true;
    }
    return 0;
}

static inline void func_00243BC8(s32 arg0, text_window_190* arg1) {
    if (arg0) {}
    if (arg1->LinesToDisplay != 0x14) {
        arg1->LineRenderArray[arg1->LinesToDisplay + 0x1] = arg1->LineRenderArray[0x0];
        arg1->LinesToDisplay++;
        arg1->LineRenderArray[0x0] = 0x0;
    }
}

void Calculate_textbox_width(text_window* curr_textbox) {
    text_window_17c* sub17c;
    text_window_190* spB0;
    byte var_a0;
    byte var_s8;
    int var_s6;
    int var_s7;
    byte var_s4;
    char* var_s3;
    int var_s2;
    int var_s1;
    byte* var_s0;
    int var_v1;
    byte var_a2;
    byte var_a1;
    int spA0;

    sub17c = &curr_textbox->unk17C;
    spB0 = &curr_textbox->unk190;
    var_s4 = false;
    curr_textbox->windowWidth = 0x0;
    curr_textbox->LineCount = 0x1;
    var_s7 = 0x0;
    var_s1 = 0x0;
    for (var_v1 = 0x0; var_v1 < 0x14; var_v1++) {
        curr_textbox->CharsPerLine[var_v1] = 0x0;
    }
    curr_textbox->windowWidth = spB0->LineRenderArray[0x1];
    if (spB0->LineRenderArray[0x1] != 0x0) {
        curr_textbox->LineCount++;
    }

    var_s3 = sub17c->Text_offset;
    // var_s8 = false;
    var_s2 = 0;

    do {
        var_s8 = 0;
        var_s6 = 0;
        var_s0 = 0;
        var_a0 = var_s3[0];

        if (var_a0 != 0xFF) {
            var_s6 = 1;
            var_s0 = var_s3;
            if (var_a0 >= 0x80) {
                var_s2 += 2;
                var_s3 += 2;
                if(var_s4) {
                    var_s2 += 2;
                }
                spA0 = 1;
            } else {
                var_s2 += 1;
                var_s3 += 1;
                spA0 = 0;
            }
        } else {
            var_a1 = var_s3[0x1];
            switch (var_a1) {
                case 0xFF:
                    var_s8 = true;
                    break;
                case 0xFE:
                    var_s8 = true;
                    break;
                case 0xFD:
                    if (var_s7 != 0x0) {
                        if (var_s7 < curr_textbox->LineCount) {
                            var_s7 = curr_textbox->LineCount;
                        }
                    } else {
                        var_s7 = curr_textbox->LineCount;
                    }

                    if (var_s1 <= 0x13) {
                        curr_textbox->CharsPerLine[var_s1] = var_s2;
                        var_s1 += 0x1;
                    }
                    if (curr_textbox->windowWidth <= var_s2) {
                        curr_textbox->windowWidth = var_s2;
                    }
                    var_s2 = 0x0;
                    curr_textbox->LineCount = 0x1;
                    if (spB0->LineRenderArray[0x1] != 0x0) {
                        curr_textbox->LineCount++;
                    }
                    var_s3 = var_s3 + 0x2;
                    break;
                case 0xFC:
                    if ((curr_textbox->flags & unk2) != NONE) {
                        if (0x2C <= var_s2) {
                            var_s2 = 0x2c;
                        }
                    } else if (0x3C <= var_s2) {
                        var_s2 = 0x3c;
                    }
                    if (curr_textbox->windowWidth <= var_s2) {
                        curr_textbox->windowWidth = var_s2;
                    }

                    if (var_s1 <= 0x13) {
                        curr_textbox->CharsPerLine[var_s1] = (byte)var_s2;
                        var_s1 += 0x1;
                        if (var_s4) {
                            var_s1 += 0x1;
                        }
                    }

                    var_s2 = 0x0;
                    curr_textbox->LineCount++;
                    if (var_s4) {
                        curr_textbox->LineCount++;
                    }
                    var_s3 = var_s3 + 0x2;
                    break;
                case 0xFB:
                    var_s3 = var_s3 + 0x2;
                    break;
                case 0xEF:
                    var_v1 = func_0027FB70(curr_textbox, (int)(char)var_s3[0x2] & 0xffff, 0x0, 0x0);
                    if ((curr_textbox->flags & unk2) != NONE) {
                        if (var_s2 + var_v1 < 0x2d) {
                            var_s2 += var_v1;
                        } else {
                            curr_textbox->windowWidth = 0x2c;
                            curr_textbox->LineCount++;
                            if (var_s4) {
                                curr_textbox->LineCount++;
                            }
                            if (var_s1 <= 0x13) {
                                curr_textbox->CharsPerLine[var_s1] = 0x2c;
                                var_s1 += 0x1;
                            }
                            var_s2 += var_v1 + -0x2c;
                        }
                    } else {
                        if (var_s2 + var_v1 < 0x3d) {
                            var_s2 += var_v1;
                        } else {
                            curr_textbox->windowWidth = 0x3c;
                            curr_textbox->LineCount++;
                            if (var_s4) {
                                curr_textbox->LineCount++;
                            }
                            if (var_s1 <= 0x13) {
                                curr_textbox->CharsPerLine[var_s1] = 0x3c;
                                var_s1 += 0x1;
                            }
                            var_s2 += var_v1 + -0x3c;
                        }
                    }
                    var_s3 = var_s3 + 0x3;
                    break;
                case 0xEA:
                    var_v1 = func_0027F380(curr_textbox, (long)(char)var_s3[0x2] & 0xffff, 0x0, 0x0);
                    if ((curr_textbox->flags & unk2) != NONE) {
                        if (var_s2 + var_v1 < 0x2d) {
                            var_s2 += var_v1;
                        } else {
                            curr_textbox->windowWidth = 0x2c;
                            curr_textbox->LineCount++;
                            if (var_s4) {
                                curr_textbox->LineCount++;
                            }
                            if (var_s1 <= 0x13) {
                                curr_textbox->CharsPerLine[var_s1] = 0x2c;
                                var_s1 += 0x1;
                            }
                            var_s2 += var_v1 + -0x2c;
                        }
                    } else {
                        if (var_s2 + var_v1 < 0x3d) {
                            var_s2 += var_v1;
                        } else {
                            curr_textbox->windowWidth = 0x3c;
                            curr_textbox->LineCount++;
                            if (var_s4) {
                                curr_textbox->LineCount++;
                            }
                            if (var_s1 <= 0x13) {
                                curr_textbox->CharsPerLine[var_s1] = 0x3c;
                                var_s1 += 0x1;
                            }
                            var_s2 += var_v1 + -0x3c;
                        }
                    }
                    var_s3 = var_s3 + 0x4;
                    break;
                case 0xE1:
                    var_v1 = func_0027ECA0(curr_textbox, (u16)var_s3[0x2], 0x0, 0x0);
                    if ((curr_textbox->flags & unk2) != NONE) {
                        if (var_s2 + var_v1 < 0x2d) {
                            var_s2 += var_v1;
                        } else {
                            curr_textbox->windowWidth = 0x2c;
                            curr_textbox->LineCount++;
                            if (var_s4) {
                                curr_textbox->LineCount++;
                            }
                            if (var_s1 <= 0x13) {
                                curr_textbox->CharsPerLine[var_s1] = 0x2c;
                                var_s1 += 0x1;
                            }
                            var_s2 += var_v1 + -0x2c;
                        }
                    } else {
                        if (var_s2 + var_v1 < 0x3d) {
                            var_s2 += var_v1;
                        } else {
                            curr_textbox->windowWidth = 0x3c;
                            curr_textbox->LineCount++;
                            if (var_s4) {
                                curr_textbox->LineCount++;
                            }
                            if (var_s1 <= 0x13) {
                                curr_textbox->CharsPerLine[var_s1] = 0x3c;
                                var_s1 += 0x1;
                            }
                            var_s2 += var_v1 + -0x3c;
                        }
                    }
                    var_s3 = var_s3 + 0x3;
                    break;
                case 0xE6:
                    var_v1 = func_0027F760(curr_textbox, 0x0, 0x0, 0x0);
                    if ((curr_textbox->flags & unk2) != NONE) {
                        if (var_s2 + var_v1 < 0x2d) {
                            var_s2 += var_v1;
                        } else {
                            curr_textbox->windowWidth = 0x2c;
                            curr_textbox->LineCount++;
                            if (var_s4) {
                                curr_textbox->LineCount++;
                            }
                            if (var_s1 <= 0x13) {
                                curr_textbox->CharsPerLine[var_s1] = 0x2c;
                                var_s1 += 0x1;
                            }
                            var_s2 += var_v1 + -0x2c;
                        }
                    } else {
                        if (var_s2 + var_v1 < 0x3d) {
                            var_s2 += var_v1;
                        } else {
                            curr_textbox->windowWidth = 0x3c;
                            curr_textbox->LineCount++;
                            if (var_s4) {
                                curr_textbox->LineCount++;
                            }
                            if (var_s1 <= 0x13) {
                                curr_textbox->CharsPerLine[var_s1] = 0x3c;
                                var_s1 += 0x1;
                            }
                            var_s2 += var_v1 + -0x3c;
                        }
                    }
                    var_s3 = var_s3 + 0x3;
                    break;
                case 0xE5:
                case 0xDF:
                case 0xDE:
                case 0xD8:
                case 0xD7:
                case 0xD6:
                case 0xD5:
                case 0xD4:
                    var_s3 = var_s3 + 0x3;
                    break;
                case 0xCF:
                case 0xCE:
                    var_s3 = var_s3 + 0x4;
                    break;
                case 0xCD:
                    var_s3 = var_s3 + 0x2;
                    break;
                case 0xCC:
                    var_s3 = var_s3 + 0x4;
                    break;
                case 0xCB:
                    var_s3 = var_s3 + 0x2;
                    break;
                case 0xC8:
                    var_s3 = var_s3 + 0x3;
                    break;
                case 0xBF:
                case 0xBE:
                case 0xBD:
                case 0xBC:
                    var_s3 = var_s3 + 0x4;
                    break;
                case 0xBB:
                case 0xBA:
                    var_s3 = var_s3 + 0x5;
                    break;
                case 0xB9:
                case 0xB8:
                    var_s3 = var_s3 + 0x3;
                    break;
                case 0xB7:
                case 0xB6:
                    var_s3 = var_s3 + 0x4;
                    break;
                case 0xB5:
                case 0xB4:
                case 0xB3:
                case 0xB2:
                case 0xB1:
                case 0xB0:
                case 0xAF:
                case 0xAE:
                case 0xAD:
                case 0xAC:
                case 0xAB:
                case 0xAA:
                    var_s3 = var_s3 + 0x3;
                    break;
                case 0x9D:
                    var_s3 = var_s3 + 0x7;
                    break;
                case 0x9C:
                    var_s3 = var_s3 + 0x4;
                    break;
                case 0x90:
                    var_s4 = true;
                    var_s3 = var_s3 + 0x2;
                    break;
                case 0x80:
                case 0x82:
                case 0x83:
                    var_v1 = func_0027E7A0(curr_textbox, var_a1, 0x0, 0x0);
                    if ((curr_textbox->flags & unk2) != NONE) {
                        if (var_s2 + var_v1 < 0x2d) {
                            var_s2 += var_v1;
                        } else {
                            curr_textbox->windowWidth = 0x2c;
                            curr_textbox->LineCount++;
                            if (var_s4) {
                                curr_textbox->LineCount++;
                            }
                            if (var_s1 <= 0x13) {
                                curr_textbox->CharsPerLine[var_s1] = 0x2c;
                                var_s1 += 0x1;
                            }
                            var_s2 += var_v1 + -0x2c;
                        }
                    } else {
                        if (var_s2 + var_v1 < 0x3d) {
                            var_s2 += var_v1;
                        } else {
                            curr_textbox->windowWidth = 0x3c;
                            curr_textbox->LineCount++;
                            if (var_s4) {
                                curr_textbox->LineCount++;
                            }
                            if (var_s1 <= 0x13) {
                                curr_textbox->CharsPerLine[var_s1] = 0x3c;
                                var_s1 += 0x1;
                            }
                            var_s2 += var_v1 + -0x3c;
                        }
                    }
                    var_s3 = var_s3 + 0x2;
                    break;
                case 0x81:
                    var_v1 = func_0027E510(curr_textbox, var_a1, 0x0, 0x0);
                    if ((curr_textbox->flags & unk2) != NONE) {
                        if (var_s2 + var_v1 < 0x2d) {
                            var_s2 += var_v1;
                        } else {
                            curr_textbox->windowWidth = 0x2c;
                            curr_textbox->LineCount++;
                            if (var_s4) {
                                curr_textbox->LineCount++;
                            }
                            if (var_s1 <= 0x13) {
                                curr_textbox->CharsPerLine[var_s1] = 0x2c;
                                var_s1 += 0x1;
                            }
                            var_s2 += var_v1 + -0x2c;
                        }
                    } else {
                        if (var_s2 + var_v1 < 0x3d) {
                            var_s2 += var_v1;
                        } else {
                            curr_textbox->windowWidth = 0x3c;
                            curr_textbox->LineCount++;
                            if (var_s4) {
                                curr_textbox->LineCount++;
                            }
                            if (var_s1 <= 0x13) {
                                curr_textbox->CharsPerLine[var_s1] = 0x3c;
                                var_s1 += 0x1;
                            }
                            var_s2 += var_v1 + -0x3c;
                        }
                    }
                    var_s3 = var_s3 + 0x2;
                    break;
                    // }
                    // else {
                default:
                    var_s8 = true;
                    break;

            }
        }

        var_a2 = false;
            var_a0 = var_s3[0];
            if (var_a0 == 0xff) {
                var_a1 = var_s3[0x1];
                if (var_a1 == 0xfc) {
                    var_a2 = true;
                } else if (var_a1 == 0xfe) {
                    var_a2 = true;
                } else if (var_a1 == 0xfd) {
                    var_a2 = true;
                } else if (var_a1 == 0xff) {
                    var_a2 = true;
                }
            }

            if ((var_a2 == 0) && ((curr_textbox->flags & unk2))) {
                if (0x2C <= var_s2) {
                    if (var_s6 == 1) {
                        if (func_00243B58(curr_textbox, &curr_textbox->unk190, var_s0)) {
                            if (spA0 != 0x0) {
                                if (var_s2 >= 2) {
                                    var_s2 += -0x2;
                                }
                            } else if (var_s2 > 0) {
                                var_s2 += -0x1;
                            }

                            curr_textbox->LineCount++;
                            if (var_s4) {
                                curr_textbox->LineCount++;
                            }
                            if (var_s1 <= 0x13) {
                                curr_textbox->CharsPerLine[var_s1] = (byte)var_s2;
                                var_s1 += 0x1;
                            }
                            curr_textbox->windowWidth = var_s2;
                            var_s2 = 0x0;
                        } else {
                            var_s0 = var_s3;
                            var_s6 = func_00243760(curr_textbox, &curr_textbox->unk190, var_s0);
                            if (!var_s6) {
                                curr_textbox->LineCount++;
                                if (var_s4) {
                                    curr_textbox->LineCount++;
                                }
                                if (var_s1 <= 0x13) {
                                    curr_textbox->CharsPerLine[var_s1] = 0x2c;
                                    var_s1 += 0x1;
                                }
                                curr_textbox->windowWidth = 0x2c;
                                var_s2 = 0x0;
                            }
                        }
                        *(undefined4*)&curr_textbox->unk190.field272_0x194 = 0x0;
                        curr_textbox->unk190.field276_0x198 = 0x0;
                    } else {
                        curr_textbox->LineCount++;
                        if (var_s4) {
                            curr_textbox->LineCount++;
                        }
                        if (var_s1 <= 0x13) {
                            curr_textbox->CharsPerLine[var_s1] = 0x2c;
                            var_s1 += 0x1;
                        }
                        curr_textbox->windowWidth = 0x2c;
                        var_s2 = 0x0;
                    }
                }
            } else if (0x3c < var_s2) {
                curr_textbox->windowWidth = 0x3c;
                curr_textbox->LineCount++;
                if (var_s4) {
                    curr_textbox->LineCount++;
                }
                if (var_s1 <= 0x13) {
                    curr_textbox->CharsPerLine[var_s1] = var_s2;
                    var_s1 += 0x1;
                }
                var_s2 = 0x0;
            }
    } while (!var_s8);

    if ((var_s2 != 0x0) && (var_s1 <= 0x13)) {
        curr_textbox->CharsPerLine[var_s1] = (byte)var_s2;
        if ((var_s4)) {
            curr_textbox->LineCount++;
        }
    }

    if (curr_textbox->windowWidth < var_s2) {
        curr_textbox->windowWidth = var_s2;
    }

    if (curr_textbox->LineCount < var_s7) {
        curr_textbox->LineCount = var_s7;
    }

    if (((curr_textbox->field3_0x6 != 0x1) && (curr_textbox->Type == 0x5)) && (curr_textbox->LineCount < 0x3)) {
        curr_textbox->LineCount = 0x3;
    }
    if (curr_textbox->field21_0x20 != 0x0) {
        switch (curr_textbox->Type) {
            case 1:
                {
                    int a1;
                    a1 = curr_textbox->field21_0x20;
                    if (curr_textbox->field3_0x6 == 0x1) {
                        a1 = 0x0;
                        curr_textbox->field223_0x160 = 0x1;
                    }
                    if (spB0->LineRenderArray[0x1] != 0x0) {
                        if (curr_textbox->LineCount < a1 + 0x1) {
                            curr_textbox->LineCount = a1 + 0x1;
                        }
                    }
                    else if (curr_textbox->LineCount < a1) {
                        curr_textbox->LineCount = a1;
                    }
                }
                break;
            case 5:
                {
                    int a2;
                    a2 = curr_textbox->field21_0x20;
                    if (curr_textbox->field3_0x6 == 0x1) {
                        a2 = 0x0;
                    }
                    if (curr_textbox->field23_0x28 == 0x10) {
                        if (curr_textbox->LineCount < a2) {
                            for (var_v1 = 0x0; var_v1 < a2 - curr_textbox->LineCount; var_v1++)
                            {
                                func_00243BC8(0, &curr_textbox->unk190);
                            }
                            curr_textbox->LineCount = a2;
                        }
                    } else if (curr_textbox->LineCount < a2) {
                        curr_textbox->LineCount = a2;
                    }
                }
                break;
        }
    }
}