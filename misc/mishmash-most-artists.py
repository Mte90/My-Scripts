#!/usr/bin/env python3
import sqlite3
from sqlite3 import Error

# Read a database from https://github.com/nicfit/MishMash and print a list of artists with more than 10 tracks

def create_connection(db_file):
    conn = None
    try:
        conn = sqlite3.connect(db_file)
    except Error as e:
        print(e)

    return conn


def select_all_tracks_grouped(conn):
    cur = conn.cursor()
    cur.execute("SELECT artists.name, COUNT(*) FROM tracks JOIN artists ON artists.id = tracks.artist_id GROUP BY artist_id HAVING COUNT(*) > 10 ORDER BY COUNT(*)")
    rows = cur.fetchall()

    for row in rows:
        print(str(row[0]) + ': ' + str(row[1]))


def main():
    database = r"./mishmash.db"

    conn = create_connection(database)
    with conn:
        print("Getting the list of Artists with more than 10 tracks")
        select_all_tracks_grouped(conn)


if __name__ == '__main__':
    main()
