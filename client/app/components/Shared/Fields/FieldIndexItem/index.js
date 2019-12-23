/**
 *
 * Field Component
 *
 *
 */

import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import {
  Button, Card, CardContent, CardActions,
  Typography, Grid, Collapse, Box
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import AddIcon from '@material-ui/icons/Add';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/GlobalSettings/Field/messages';
import WrappedNavLink from 'components/Shared/WrappedNavLink';

import FieldForm from 'components/Shared/Fields/FieldForms/FieldForm';

import DiverstPagination from 'components/Shared/DiverstPagination';
import DiverstLoader from 'components/Shared/DiverstLoader';

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
  fieldTitleButton: {
    textTransform: 'none',
  },
  fieldFormCollapse: {
    width: '100%',
  },
  fieldFormContainer: {
    width: '100%',
    padding: theme.spacing(1.5),
  },
});

export function FieldList(props, context) {
  const { classes, ...rest } = props;

  const { field } = props;

  const [form, setForm] = useState(false);

  return (
    <Grid item key={field.id} className={classes.fieldListItem}>
      <Card>
        <CardContent>
          <Typography variant='h5' component='h2' display='inline'>
            {field.title}
          </Typography>
        </CardContent>
        <CardActions>
          <Button
            color='primary'
            size='small'
            onClick={() => {
              setForm(!form);
            }}
          >
            <DiverstFormattedMessage {...messages.edit} />
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
            <DiverstFormattedMessage {...messages.delete} />
          </Button>
        </CardActions>
      </Card>
      <Collapse in={form}>
        <FieldForm
          edit
          field={field}
          fieldAction={props.updateFieldBegin}
          cancelAction={() => setForm(false)}
          {...rest}
        />
      </Collapse>
    </Grid>
  );
}

FieldList.propTypes = {
  classes: PropTypes.object,
  field: PropTypes.object,
  isLoading: PropTypes.bool,
  updateFieldBegin: PropTypes.func,
  deleteFieldBegin: PropTypes.func,
  isCommitting: PropTypes.bool,
  commitSuccess: PropTypes.bool,
};

export default compose(
  memo,
  withStyles(styles),
)(FieldList);
