/**
 *
 * FieldList Component
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

  const FIELDS = {
    text: {
      field: {
        type: 'TextField',
      },
      action: props.createFieldBegin,
    }
  };

  const [expandedFields, setExpandedFields] = useState({});

  const [showFieldForm, setShowFieldForm] = useState(false);
  const [enableFieldForm, setEnableFieldForm] = useState(showFieldForm);
  const [fieldFormType, setFieldFormType] = useState(undefined);

  useEffect(() => {
    if (showFieldForm && props.commitSuccess)
      hideFieldForm();
  }, [props.commitSuccess]);

  const renderFieldForm = (type) => {
    setFieldFormType(type);
    setEnableFieldForm(true);
    setShowFieldForm(true);
  };

  // Done to allow the collapse to transition out before clearing the field form
  const hideFieldForm = () => {
    setShowFieldForm(false);
  };

  const disableFieldForm = () => {
    setEnableFieldForm(false);
    setFieldFormType(undefined);
  };

  return (
    <React.Fragment>
      <Grid container spacing={3} justify='flex-end'>
        <Grid item>
          <Button
            variant='contained'
            color='primary'
            size='large'
            onClick={() => renderFieldForm('text')}
            startIcon={<AddIcon />}
          >
            <DiverstFormattedMessage {...messages.newTextField} />
          </Button>
        </Grid>
        <Collapse
          className={classes.fieldFormCollapse}
          in={showFieldForm}
          component='span'
          onExited={() => disableFieldForm()}
        >
          <div className={enableFieldForm ? classes.fieldFormContainer : undefined}>
            {enableFieldForm && (
              <FieldForm
                field={FIELDS[fieldFormType].field}
                fieldAction={FIELDS[fieldFormType].action}
                cancelAction={hideFieldForm}
                {...rest}
              />
            )}
          </div>
        </Collapse>
      </Grid>
      <Box mb={2} />
      <DiverstLoader isLoading={props.isLoading}>
        <Grid container spacing={3}>
          { /* eslint-disable-next-line arrow-body-style */ }
          {props.fields && Object.values(props.fields).map((field, i) => {
            return (
              <Grid item key={field.id} className={classes.fieldListItem}>
                <Card>
                  <CardContent>
                    <Button
                      className={classes.fieldTitleButton}
                      color='primary'
                      onClick={() => {
                        renderFieldForm(field, props.updateFieldBegin);
                        window.scrollTo(0, 0);
                      }}
                    >
                      <Typography variant='h5' component='h2' display='inline'>
                        {field.title}
                      </Typography>
                    </Button>
                  </CardContent>
                  <CardActions>
                    <Button
                      color='primary'
                      size='small'
                      to='#'
                      component={WrappedNavLink}
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
              </Grid>
            );
          })}
        </Grid>
      </DiverstLoader>
      <DiverstPagination
        isLoading={props.isLoading}
        rowsPerPage={5}
        count={props.fieldTotal}
        handlePagination={props.handlePagination}
      />
    </React.Fragment>
  );
}

FieldList.propTypes = {
  classes: PropTypes.object,
  fields: PropTypes.object,
  fieldTotal: PropTypes.number,
  isLoading: PropTypes.bool,
  createFieldBegin: PropTypes.func,
  updateFieldBegin: PropTypes.func,
  deleteFieldBegin: PropTypes.func,
  handlePagination: PropTypes.func,
  isCommitting: PropTypes.bool,
  commitSuccess: PropTypes.bool,
};

export default compose(
  memo,
  withStyles(styles),
)(FieldList);