from enum import Enum

class Type(str, Enum):
    BOOK = "book"
    PROJECT =  "project"
    COURSE = "course"