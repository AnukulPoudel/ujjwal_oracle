from django.http import JsonResponse
import oracledb
from django.views.decorators.csrf import csrf_exempt
import json

from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import oracledb
import json

@csrf_exempt
def createTables(request):
    if request.method == 'POST':
        try:
            # Parse the JSON body of the request
            data = json.loads(request.body)
            prod_id = data.get('prod_id')
            quantity = data.get('quantity')
            warehouse = data.get('warehouse')

            # Validate the parameters
            if prod_id is None or quantity is None or warehouse is None:
                return JsonResponse({'error': 'Missing parameters. Expected prod_id, quantity, and warehouse.'}, status=400)

            # Convert prod_id and quantity to integers
            try:
                prod_id = int(prod_id)
                quantity = int(quantity)
            except ValueError:
                return JsonResponse({'error': 'prod_id and quantity must be integers.'}, status=400)

            connection = oracledb.connect(
                user='COMP214_M24_zo_107',
                password='password',
                dsn='199.212.26.208:1521/SQLD'
            )
            cursor = connection.cursor()

            # PL/SQL block to execute
            plsql_block = """
            BEGIN
                sp_update_inventory(:prod_id, :quantity, :warehouse);
            END;
            """

            # Execute the PL/SQL block with bind variables
            cursor.execute(plsql_block, {'prod_id': prod_id, 'quantity': quantity, 'warehouse': warehouse})

            return JsonResponse({'message': 'Stored procedure sp_update_inventory executed successfully.'})

        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON'}, status=400)
        except oracledb.DatabaseError as e:
            return JsonResponse({'error': str(e)}, status=400)
        finally:
            cursor.close()
            connection.close()
    else:
        return JsonResponse({'error': 'Only POST method is allowed'}, status=405)


@csrf_exempt
def handle(request):
    if request.method == 'POST':
        # Parse the JSON body of the request
        try:
            data = json.loads(request.body)
            prod_id = data.get('prod_id')
        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON'}, status=400)
        
        if prod_id is None:
            return JsonResponse({'error': 'prod_id parameter is required'}, status=400)
        
        try:
            # Convert prod_id to integer
            prod_id = int(prod_id)
        except ValueError:
            return JsonResponse({'error': 'prod_id must be an integer'}, status=400)

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
            BEGIN
                v_inventory_level := fn_get_product_inventory(:prod_id);
                dbms_output.put_line(
                    'Inventory : ' || v_inventory_level || ' for product id=' || :prod_id
                );
            END;
            """

            # Execute the PL/SQL block with bind variable
            cursor.execute(plsql_block, {'prod_id': prod_id})

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

    else:
        return JsonResponse({'error': 'Only POST method is allowed'}, status=405)
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
            prod_id NUMBER := 6;
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