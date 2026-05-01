"""initial migration

Revision ID: 13967a17ebec
Revises: 
Create Date: 2026-05-01 13:53:20.779003

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
import sqlmodel


# revision identifiers, used by Alembic.
revision: str = '13967a17ebec'
down_revision: Union[str, Sequence[str], None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # 1. Create user table without the foreign key
    op.create_table('user',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('email', sqlmodel.sql.sqltypes.AutoString(), nullable=False),
    sa.Column('current_focus_unit_id', sa.Integer(), nullable=True),
    sa.Column('created_at', sa.DateTime(), nullable=False),
    sa.Column('updated_at', sa.DateTime(), nullable=False),
    sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_user_email'), 'user', ['email'], unique=True)

    # 2. Create executionunit table
    op.create_table('executionunit',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('title', sqlmodel.sql.sqltypes.AutoString(), nullable=False),
    sa.Column('type', sqlmodel.sql.sqltypes.AutoString(), nullable=False),
    sa.Column('total_hours', sa.Float(), nullable=False),
    sa.Column('start_date', sa.DateTime(), nullable=True),
    sa.Column('end_date', sa.DateTime(), nullable=True),
    sa.Column('status', sqlmodel.sql.sqltypes.AutoString(), nullable=False),
    sa.Column('last_activity_at', sa.DateTime(), nullable=False),
    sa.Column('user_id', sa.Integer(), nullable=False),
    sa.Column('created_at', sa.DateTime(), nullable=False),
    sa.Column('updated_at', sa.DateTime(), nullable=False),
    sa.ForeignKeyConstraint(['user_id'], ['user.id'], ),
    sa.PrimaryKeyConstraint('id')
    )

    # 3. Create step table
    op.create_table('step',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('execution_unit_id', sa.Integer(), nullable=False),
    sa.Column('title', sqlmodel.sql.sqltypes.AutoString(), nullable=False),
    sa.Column('order_index', sa.Integer(), nullable=False),
    sa.Column('weight', sa.Float(), nullable=False),
    sa.Column('allocated_hours', sa.Float(), nullable=False),
    sa.Column('deadline', sa.DateTime(), nullable=True),
    sa.Column('status', sqlmodel.sql.sqltypes.AutoString(), nullable=False),
    sa.Column('created_at', sa.DateTime(), nullable=False),
    sa.Column('updated_at', sa.DateTime(), nullable=False),
    sa.ForeignKeyConstraint(['execution_unit_id'], ['executionunit.id'], ),
    sa.PrimaryKeyConstraint('id')
    )

    # 4. Add the foreign key constraint to user
    op.create_foreign_key(
        'fk_user_current_focus_unit_id', 
        'user', 
        'executionunit', 
        ['current_focus_unit_id'], 
        ['id']
    )


def downgrade() -> None:
    # 1. Remove the foreign key from user to avoid cyclic issues
    op.drop_constraint('fk_user_current_focus_unit_id', 'user', type_='foreignkey')
    
    # 2. Drop tables in reverse order
    op.drop_table('step')
    op.drop_table('executionunit')
    op.drop_index(op.f('ix_user_email'), table_name='user')
    op.drop_table('user')
