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
import messages from 'containers/Shared/Field/messages';
import WrappedNavLink from 'components/Shared/WrappedNavLink';

import FieldForm from 'components/Shared/Fields/FieldForms/FieldForm';
import { injectIntl, intlShape } from 'react-intl';

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

  const { field, intl } = props;

  const [form, setForm] = useState(false);

  return (
    <Grid item key={field.id} className={classes.fieldListItem}>
      <Card>
        <CardContent>
          <Typography variant='h5' component='h2' display='inline' color='primary'>
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
              if (confirm(intl.formatMessage(messages.delete_confirm)))
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
          currentEnterprise={props.currentEnterprise}
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
  intl: intlShape.isRequired,
  classes: PropTypes.object,
  field: PropTypes.object,
  isLoading: PropTypes.bool,
  updateFieldBegin: PropTypes.func,
  deleteFieldBegin: PropTypes.func,
  isCommitting: PropTypes.bool,
  commitSuccess: PropTypes.bool,
  currentEnterprise: PropTypes.object,
};

export default compose(
  injectIntl,
  memo,
  withStyles(styles),
)(FieldList);
