/**
 *
 * FieldList Component
 *
 *
 */

import React, { memo, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import { NavLink } from 'react-router-dom';
import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  Button, Card, CardContent, CardActions,
  Typography, Grid, Link, TablePagination, Collapse
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import { FormattedMessage } from 'react-intl';
import messages from 'containers/GlobalSettings/Field/messages';
import WrappedNavLink from 'components/Shared/WrappedNavLink';

import FieldForm from 'components/Shared/Fields/FieldForms/FieldForm';

const styles = theme => ({
  fieldListItem: {
    width: '100%',
  },
  fieldListItemDescription: {
    paddingTop: 8,
  },
  errorButton: {
    color: theme.palette.error.main,
  },
});

export function FieldList(props, context) {
  const { classes } = props;
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(5);
  const [expandedFields, setExpandedFields] = useState({});

  const [fieldForm, setFieldForm] = useState(undefined);

  const handleChangePage = (event, newPage) => {
    setPage(newPage);
    props.handlePagination({ count: rowsPerPage, page: newPage });
  };

  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(+event.target.value);
    props.handlePagination({ count: +event.target.value, page });
  };

  const renderFieldForm = field => {
    setFieldForm(<FieldForm
      field={field}
      cancelAction={fieldFormCancel}
    />);
  };

  const fieldFormCancel = () => {
    setFieldForm(undefined);
  };

  return (
    <React.Fragment>
      <Grid container spacing={3}>
        <Grid item>
          <Button
            variant='contained'
            to={'#'}
            color='primary'
            size='large'
            component={WrappedNavLink}
          >
            <FormattedMessage {...messages.new} />
          </Button>
        </Grid>
        {fieldForm && <Grid item xs={12}>{fieldForm}</Grid>}
        { /* eslint-disable-next-line arrow-body-style */ }
        {props.fields && Object.values(props.fields).map((field, i) => {
          return (
            <Grid item key={field.id} className={classes.fieldListItem}>
              <Card>
                <CardContent>
                  <Button
                    size='small'
                    onClick={() => {
                      renderFieldForm(field);
                      window.scrollTo(0, 0);
                    }}
                  >
                    {field.title}
                  </Button>
                </CardContent>
                <CardActions>
                  <Button
                    size='small'
                    to='#'
                    component={WrappedNavLink}
                  >
                    <FormattedMessage {...messages.edit} />
                  </Button>
                  <Button
                    size='small'
                    className={classes.errorButton}
                    onClick={() => {
                      /* eslint-disable-next-line no-alert, no-restricted-globals */
                      if (confirm('Delete field?'))
                        props.deleteFieldBegin(field.id);
                    }}
                  >
                    <FormattedMessage {...messages.delete} />
                  </Button>
                </CardActions>
              </Card>
            </Grid>
          );
        })}
      </Grid>
      <TablePagination
        component='div'
        page={page}
        rowsPerPageOptions={[5, 10, 25]}
        rowsPerPage={rowsPerPage}
        count={props.fieldTotal || 0}
        onChangePage={handleChangePage}
        onChangeRowsPerPage={handleChangeRowsPerPage}
        backIconButtonProps={{
          'aria-label': 'Previous Page',
        }}
        nextIconButtonProps={{
          'aria-label': 'Next Page',
        }}
      />
    </React.Fragment>
  );
}

FieldList.propTypes = {
  classes: PropTypes.object,
  fields: PropTypes.object,
  fieldTotal: PropTypes.number,
  deleteFieldBegin: PropTypes.func,
  handlePagination: PropTypes.func
};

export default compose(
  memo,
  withStyles(styles),
)(FieldList);
