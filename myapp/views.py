from django.http import JsonResponse
import oracledb


def createTables(request):
    connection = oracledb.connect(
        user='COMP214_M24_zo_107',
        password='password',
        dsn='199.212.26.208:1521/SQLD'
    )
    cursor = connection.cursor()

    plsql_block = """
    BEGIN
        sp_update_inventory(5, 100, 'Warehouse B');
    END;
    """

    try:
        # Execute the PL/SQL block
        cursor.execute(plsql_block)
        return JsonResponse({'message': 'Stored procedure sp_update_inventory executed successfully.'})
    except oracledb.DatabaseError as e:
        return JsonResponse({'error': str(e)}, status=400)
    finally:
        cursor.close()
        connection.close()


def handle(request):
    connection = oracledb.connect(
        user='COMP214_M24_zo_107',
        password='password',
        dsn='199.212.26.208:1521/SQLD'
    )
    cursor = connection.cursor()

    try:
        # Enable DBMS_OUTPUT
        cursor.callproc('dbms_output.enable')

        # PL/SQL block to execute
        plsql_block = """
        DECLARE
            v_inventory_level NUMBER;
            prod_id NUMBER := 5;
        BEGIN
            v_inventory_level := fn_get_product_inventory(prod_id);
            dbms_output.put_line(
                'Inventory : ' || v_inventory_level || ' for product id=' || prod_id
            );
        END;
        """

        # Execute the PL/SQL block
        cursor.execute(plsql_block)

        # Fetch output from DBMS_OUTPUT
        output = []
        while True:
            # Create a variable to hold the output line
            output_line = cursor.var(oracledb.STRING)
            cursor.callproc('dbms_output.get_line', [output_line, None])
            if output_line.getvalue() is None:
                break
            output.append(output_line.getvalue())

        return JsonResponse({'output': output})

    except oracledb.DatabaseError as e:
        return JsonResponse({'error': str(e)}, status=400)

    finally:
        cursor.close()
        connection.close()